extends OptionButton

func _ready():
	for ritual in global.data.keys():
		add_item(ritual)

func _on_item_selected(index:int):
	signals.emit_signal("ritual_selected", global.data.keys()[index-2])
