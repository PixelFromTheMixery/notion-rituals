extends HTTPRequest

var safety_net: String

func _ready():
	signals.connect("fetch_databases", fetch_json)

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
		"https://api.notion.com/v1/search", global.request_headers, HTTPClient.METHOD_POST, json
	)

func rename_key(dict: Dictionary, old_key: String, new_key: String) -> void:
	if dict.has(old_key):  # Check if the old key exists
		dict[new_key] = dict[old_key]  # Copy the value to the new key
		dict.erase(old_key)  # Remove the old key

func database_list(_result, _response_code, _headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var rituals: Dictionary = {"rituals": []}
	var index = 0
	for database in json['results']:
		var ritual_name = database['title'][0]['text']['content']
		rituals['rituals'].append({ritual_name:{"id": database['id'], "steps": []}})
		for key in database['properties'].keys():
			if " - " in key:
				var unpacked_column = key.split(' - ')
				rituals['rituals'][index][ritual_name]["steps"].append([unpacked_column[0], unpacked_column[2], int(unpacked_column[1])])
		rituals['rituals'][index][ritual_name]["steps"].sort()
		index += 1
	# Sort rituals['rituals'] by ritual_name
	rituals['rituals'].sort_custom(func(a, b): return a.keys()[0] < b.keys()[0])
	for i in range(len(rituals['rituals'])):
		rename_key(rituals['rituals'][i],rituals['rituals'][i].keys()[0],rituals['rituals'][i].keys()[0].substr(3))
	global.save_to_json("user://rituals.json", rituals)


