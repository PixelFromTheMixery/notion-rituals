extends OptionButton

@onready var api_panel = get_node("/root/Control_Base/Panel_API")
@onready var api_tedit = get_node("/root/Control_Base/Panel_API/VBox_API/TEdit_API")
@onready var api_button = get_node("/root/Control_Base/Panel_API/VBox_API/Button_API")

func _ready():
	signals.connect("refresh_rituals", reload_menu)
	reload_menu()

func reload_menu():
	while item_count > 4:
		remove_item(4)
	for ritual in global.base.keys():
		add_item(ritual)

func _on_item_selected(index:int):
	if index == 0:
		pass
	if index == 1:
		signals.fetch_databases.emit()		
	if index == 2:
		api_panel.show()
	elif index > 2:
		global.selected = global.base.keys()[index-4]
		signals.ritual_selected.emit(global.base[global.selected]['steps'])

func _on_button_api_pressed():
	api_panel.hide()
	var data = {"api_key": api_tedit.text}
	global.save_to_json("user://settings.json", data)
	signals.api_set.emit()
	api_tedit.text = ""
