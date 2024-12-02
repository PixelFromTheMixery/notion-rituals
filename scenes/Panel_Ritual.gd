extends Panel

@onready var no_ritual_warning: Label = $Label_Start
@onready var sequence_screen: VBoxContainer = $VBox_List
@onready var sequence_info: Label = $VBox_List/Label_SequenceInfo
@onready var ritual_screen: VBoxContainer = $VBox_Ritual


func _ready():
	signals.connect("ritual_selected", show_sequence)

func show_sequence():
	ritual_screen.hide()
	no_ritual_warning.hide()
	sequence_screen.show()

	var sequence_count = str(global.data[global.ritual].keys().size())+" steps will take "
	
	var step_time_total = 0
	for step in global.data[global.ritual]:
		step_time_total += global.data[global.ritual][step]['time']
	var sequence_time = str(step_time_total) + " minutes"

	sequence_info.text = sequence_count + sequence_time

func _on_button_start_pressed():
	sequence_screen.hide()
	ritual_screen.show()
