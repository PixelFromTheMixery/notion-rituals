extends VBoxContainer

var step_object = preload("res://scenes/prefabs/step_info.tscn")

var modified_ritual: Array

func _ready():
	signals.connect("ritual_selected", generate_sequence)

func generate_sequence(ritual: Array):
	modified_ritual = []
	for child in get_children():
		child.queue_free()
	for i in ritual.size():
		modified_ritual.append(ritual[i])
		var instance = step_object.instantiate()
		add_child(instance)
		instance.id = i
		instance.title.text = ritual[i][0]
		instance.time.text = str(ritual[i][1])
		instance.connect("step_action", adjust_sequence)
		if i == 0:
			instance.up.disabled = true
		if i == ritual.size()-1:
			instance.down.disabled = true

func adjust_sequence(step: int, action: String):
	match action:
		"skip":
			modified_ritual.pop_at(step)
		"up":
			modified_ritual.insert(step-1,modified_ritual.pop_at(step))
		"down":
			modified_ritual.insert(step+1,modified_ritual.pop_at(step))
		_:
			pass
	signals.ritual_selected.emit(modified_ritual)

func _on_button_start_pressed():
	global.ritual = modified_ritual
