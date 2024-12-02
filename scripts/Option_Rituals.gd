extends OptionButton

func _ready():
	for ritual in global.data.keys():
		add_item(ritual)

func _on_item_selected(index:int):
	global.ritual = global.data.keys()[index-2]
	signals.emit_signal("ritual_selected")
