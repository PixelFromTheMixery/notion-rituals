extends Node

var base: Dictionary
var selected: String
var ritual: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var json = JSON.new()
	var json_str = load_from_file("res://scripts/routines.json")
	if json_str != null:
		var error = json.parse(json_str)
		if error == OK:
			global.base = json.data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_str, " at line ", json.get_error_line())

func load_from_file(filepath: String):
	if FileAccess.file_exists(filepath):
		var file = FileAccess.open(filepath, FileAccess.READ)
		var content = file.get_as_text()
		return content
	else: print("File not found")