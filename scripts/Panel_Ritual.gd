extends Panel

@onready var no_ritual_warning: Label = $Label_Start
@onready var sequence_screen: VBoxContainer = $VBox_List
@onready var sequence_list:  VBoxContainer = $VBox_List/Scroll_Sequence/VBox_Sequence
@onready var sequence_info: Label = $VBox_List/Label_SequenceInfo
@onready var ritual_screen: VBoxContainer = $VBox_Ritual


func _ready():
	signals.connect("ritual_selected", calculate_sequence)

func calculate_sequence(ritual: Array):
	var sequence_count = str(ritual.size())+" steps will take "
	
	var step_time_total = 0
	for step in ritual:
		step_time_total += step[1]
	var sequence_time = str(step_time_total) + " minutes"

	sequence_info.text = sequence_count + sequence_time

func _on_button_start_pressed():
	sequence_screen.hide()
	ritual_screen.show()

func _on_option_rituals_item_selected(index:int):
	if index > 2:
		ritual_screen.hide()
		no_ritual_warning.hide()
		sequence_screen.show()