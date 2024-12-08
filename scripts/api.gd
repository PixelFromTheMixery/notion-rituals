extends HTTPRequest

var request_headers: PackedStringArray
var safety_net: String

func _ready():
	signals.connect("fetch_databases", fetch_json)
	signals.connect("submit_result", send_entry)
	signals.connect("api_set", read_api)
	read_api()

func read_api():
	var json = JSON.new()
	var json_str = global.load_from_file("user://settings.json")
	if json_str != null:
		var error = json.parse(json_str)
		if error == OK:
			request_headers = PackedStringArray([
				"Authorization: Bearer %s" % json.data['api_key'],
				"Content-Type: application/json",
				"Notion-Version: 2022-06-28",
	])
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_str, " at line ", json.get_error_line())


func fetch_json():
	request_completed.connect(database_list)
		
	var data = {
		"filter": {
			"value": "database",
			"property": "object"
		}
	}
	var json = JSON.stringify(data)
	request(
		"https://api.notion.com/v1/search", request_headers, HTTPClient.METHOD_POST, json
	)

func database_list(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var rituals: Dictionary = {}
	for database in json['results']:
		var ritual_name = database['title'][0]['text']['content'].substr(3)
		rituals[ritual_name] = {"id": database['id'], "steps": []}
		for key in database['properties'].keys():
			if " - " in key:
				var unpacked_column = key.split(' - ')
				rituals[ritual_name]["steps"].append([unpacked_column[0], unpacked_column[2], int(unpacked_column[1])])
		rituals[ritual_name]["steps"].sort()
	global.save_to_json("user://rituals.json", rituals)

func send_entry(steps: Array):
	request_completed.connect(entry_response)
	safety_net = JSON.stringify(steps)
	var props = {}
	for i in range(steps.size()):
		props[""+steps[i][0]] = {'rich_text':
			[
				{'text':
					{'content': steps[i][1]}
				}
			]
		}

	var data = {
		"parent": {"database_id" : global.base[global.selected]['id']},
		"properties": props
	}
	var json = JSON.stringify(data)
	request(
		"https://api.notion.com/v1/pages", request_headers, HTTPClient.METHOD_POST, json
	)

func entry_response(_result, response_code, _headers, _body):
	if response_code != 200:
		print("issue here")
	signals.reset.emit(response_code, safety_net)
