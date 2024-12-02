extends VBoxContainer

@onready var label_step: Label = $Label_Step

# Called when the node enters the scene tree for the first time.
func _ready():
	signals.connect("ritual_selected", start_ritual)

func start_ritual():
	label_step.text = global.data[global.ritual].keys()[0]
