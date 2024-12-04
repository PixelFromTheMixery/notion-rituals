extends Node

var api_key

var request_headers = {
    "Authorization": "Bearer %s" % api_key,
    "Content-Type": "application/json",
    "Notion-Version": "2022-06-28",
}

func fetch_json():
    $HTTPRequest.request_completed.connect(_on_request_completed)
		
    var data = {
        "filter": {
            "value": "database",
            "property": "object"
        }
    }
    $HTTPRequest.request(
        "https://api.notion.com/v1/search", request_headers, data
    )

func _on_request_completed(_result, _response_code, _headers, body):
    var json = JSON.parse_string(body.get_string_from_utf8())
    print(json["name"])