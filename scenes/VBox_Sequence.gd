extends VBoxContainer

var step_object = preload("res://scenes/prefabs/step_info.tscn")

func _ready():
	signals.connect("ritual_selected", generate_sequence)

func generate_sequence():
	print(get_child_count())
	for child in get_children():
		child.queue_free()
	for step in global.data[global.ritual]:
		var style: String
		match global.data[global.ritual][step]['type']:
			"checkbox":
				style = "Do"
			"rich_text":
				style = "Write"
			_:
				return "undetected type"
		var instance = step_object.instantiate()
		add_child(instance)
		instance.title.text = step
		instance.time.text = str(global.data[global.ritual][step]['time'])
		instance.step_type.text = style	
