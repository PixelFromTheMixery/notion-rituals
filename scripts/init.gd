extends Node

var data: Dictionary
var data_string: String

# Called when the node enters the scene tree for the first time.
func _ready():
	data_string = load_from_file("res://scripts/routines.json")
	data = JSON.parse_string(data_string)
	print()

func load_from_file(filepath: String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var content = file.get_as_text()
	return content
