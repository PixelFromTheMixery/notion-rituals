extends Node

var data: Dictionary
var ritual: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var json = JSON.new()
	var json_str = load_from_file("res://scripts/routines.json")
	var error = json.parse(json_str)
	if error == OK:
		global.data = json.data
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_str, " at line ", json.get_error_line())

func load_from_file(filepath: String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var content = file.get_as_text()
	return content
