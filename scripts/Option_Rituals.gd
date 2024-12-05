extends OptionButton

func _ready():
	signals.connect("refresh_rituals", reload_menu)
	reload_menu()

func reload_menu():
	while item_count > 3:
		remove_item(3)
	for ritual in global.base.keys():
		add_item(ritual)

func _on_item_selected(index:int):
	if index == 0:
		pass
	if index == 1:
		signals.fetch_databases.emit()
	elif index > 2:
		global.selected = global.base.keys()[index-3]
		signals.ritual_selected.emit(global.base[global.selected]['steps'])
