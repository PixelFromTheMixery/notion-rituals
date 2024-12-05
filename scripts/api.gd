extends HTTPRequest

var request_headers: PackedStringArray

func _ready():
	signals.connect("fetch_databases", fetch_json)
	signals.connect("submit_result", send_entry)

	var api_key = OS.get_environment("API_KEY") if OS.has_environment("API_KEY") else global.env["API_KEY"]

	request_headers = PackedStringArray([
		"Authorization: Bearer %s" % api_key,
		"Content-Type: application/json",
		"Notion-Version: 2022-06-28",
	])

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
		var ritual_name = database['title'][0]['text']['content']
		rituals[ritual_name] = {"id": database['id'], "steps": []}
		for key in database['properties'].keys():
			if " - " in key:
				var unpacked_column = key.split(' - ')
				rituals[ritual_name]["steps"].append([unpacked_column[1], int(unpacked_column[0])])
	global.save_to_json("res://scripts/rituals.json", rituals)

func send_entry(steps: Array):
	request_completed.connect(entry_response)
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

func entry_response(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
