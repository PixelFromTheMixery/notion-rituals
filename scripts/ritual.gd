extends VBoxContainer

@onready var label_step: Label = $Label_Step

# Called when the node enters the scene tree for the first time.
func _ready():
	signals.connect("ritual_selected", start_ritual)

func start_ritual(ritual: String):
	label_step.text = global.data[ritual].keys()[0]