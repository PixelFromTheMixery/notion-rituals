extends Node

var base: Dictionary
var selected: String
var ritual: Array
var env: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	signals.connect("refresh_rituals", load_rituals)

	load_rituals()

func load_rituals():
	var json = JSON.new()
	var json_str = load_from_file("user://rituals.json")
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
	else: 
		print("File %s not found" % filepath)
		if "settings" in filepath:
			signals.api_missing.emit()

func save_to_json(file_path: String, data: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		var json = JSON.stringify(data, "\t")  # Convert dictionary to a JSON string (formatted with tabs)
		file.store_string(json)  # Save the JSON string to the file
		file.close()
		print("Data saved to:", file_path)
		signals.refresh_rituals.emit()	
	else:
		print("Failed to open file for writing:", file_path)	

func load_env(file_path: String) -> Dictionary:
	var env_data = {}
	var file = FileAccess.open(file_path, FileAccess.READ)

	if file:
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line != "" and not line.begins_with("#"):  # Ignore comments and empty lines
				var parts = line.split("=")
				if parts.size() == 2:
					env_data[parts[0].strip_edges()] = parts[1].strip_edges()
		file.close()
	else:
		print("Could not open .env file at: " + file_path)

	return env_data
