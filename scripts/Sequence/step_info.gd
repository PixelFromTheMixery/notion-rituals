extends HBoxContainer

class_name step_info

@onready var time = $Label_Time
@onready var title = $Label_Step
@onready var down = $Button_Down
@onready var up = $Button_Up

var id: int

signal step_action(step: int, action: String)

func _on_button_skip_pressed():
	step_action.emit(id, "skip")

func _on_button_down_pressed():
	step_action.emit(id, "down")

func _on_button_up_pressed():
	step_action.emit(id, "up")