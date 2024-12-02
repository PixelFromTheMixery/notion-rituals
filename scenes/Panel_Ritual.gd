extends Panel

@onready var no_ritual_warning = $Label_Start
@onready var sequence_screen = $VBox_List
@onready var sequence_list = $VBox_List/Scroll_Sequence/VBox_Sequence
@onready var ritual_screen = $VBox_Ritual

func _ready():
	signals.connect("ritual_selected", generate_sequence)

func generate_sequence():
	ritual_screen.hide()
	no_ritual_warning.hide()
	sequence_screen.show()
	for step in global.data[global.ritual]:
		var step_panel = Label.new()
		step_panel.text = step
		sequence_list.add_child(step_panel)

func _on_button_start_pressed():
	print(sequence_list.get_child_count())
	while sequence_list.get_child_count() != 0:
		sequence_list.get_child(0).queue_free()
		print(sequence_list.get_child_count())
	sequence_screen.hide()
	ritual_screen.show()
