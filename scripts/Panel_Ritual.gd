extends Panel

@onready var no_ritual_warning: Label = $Label_Start
@onready var sequence_screen: VBoxContainer = $VBox_List
@onready var sequence_title: Label = $VBox_List/Label_Title
@onready var sequence_info: Label = $VBox_List/Label_SequenceInfo
@onready var ritual_screen: VBoxContainer = $VBox_Ritual
@onready var results_screen: VBoxContainer = $VBox_Result
@onready var results_title: Label = $VBox_Result/Label_Title
@onready var results_result: Label = $VBox_Result/Label_Warning
@onready var reset_button: Button = $VBox_Result/Button_Finish

func _ready():
	signals.connect("ritual_selected", calculate_sequence)
	signals.connect("submit_result", show_results)
	signals.connect("reset", reset_ready)
	signals.connect("api_missing", missing_api_message)
	signals.connect("api_set", api_added_message)

func calculate_sequence(ritual: Array):
	sequence_title.text = "Review 
	" + global.selected
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

func show_results(_result: Array):
	ritual_screen.hide()
	reset_button.disabled = true
	results_screen.show()
	results_title.text = "You've completed 
	" + global.selected

func reset_ready(response_code: int, results: String):
	results_result.show()
	reset_button.disabled = false
	if response_code == 200:
		results_result.text = "It's online. You're good to go"
	else: 
		results_result.text = "Something went wrong, have the results here for manual input" + results

func _on_button_finish_pressed():
	results_result.hide()
	results_screen.hide()
	global.selected = ""
	global.ritual = []
	no_ritual_warning.show()

func missing_api_message():
	no_ritual_warning.text = "Please select 'Add API key' from the dropdown above and set your api key"

func api_added_message():
	no_ritual_warning.text = "Please select a Ritual from the dropdown above to get started"