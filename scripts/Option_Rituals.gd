extends OptionButton

func _ready():
	for ritual in global.base.keys():
		add_item(ritual)

func _on_item_selected(index:int):
	if index == 0:
		pass
	if index == 1:
		#HTTP Request here
		pass

	if index == 2:
		pass
	else:
		global.selected = global.base.keys()[index-3]
		signals.ritual_selected.emit(global.base[global.selected])
