extends HTTPRequest

var safety_net: String

func _ready():
	signals.connect("submit_result", send_entry)

func send_entry(steps: Array):
	request_completed.connect(entry_response)
	safety_net = ""
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
		"parent": {"database_id" : global.base['rituals'][global.id][global.selected]['id']},
		"properties": props
	}
	var json = JSON.stringify(data)
	request(
		"https://api.notion.com/v1/pages", global.request_headers, HTTPClient.METHOD_POST, json
	)

func entry_response(_result, response_code, _headers, _body):
	if response_code != 200:
		print("issue here")
	signals.reset.emit(response_code, safety_net)
