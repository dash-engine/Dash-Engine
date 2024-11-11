extends ItemList

@export var context_menu: PopupMenu
var icons = {
	"textFile": "res://assets/img/textFile.png",
	"scene": "res://assets/img/sceneIcon.png",
}

var selected_action: int = -1
var input_dialog

var can_context_menu = false

func _ready():
	context_menu.add_item("Add Scene", 0)
	context_menu.add_item("Rename Scene", 1)
	context_menu.add_item("Delete Scene", 2)
	context_menu.id_pressed.connect(_on_context_menu_id_pressed)
	
	item_activated.connect(_on_scene_double_clicked)
	
	_refresh_scene_list()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			if can_context_menu:
				context_menu.visible = true
				context_menu.position = get_global_mouse_position()

func _on_context_menu_id_pressed(id: int) -> void:
	selected_action = id
	if id == 0 or id == 1:
		_show_input_dialog()
	elif id == 2:
		_on_delete_scene()

func _show_input_dialog():
	if not input_dialog:
		input_dialog = Window.new()
		input_dialog.title = "Enter Scene Name"
		add_child(input_dialog)
		
		var vbox = VBoxContainer.new()
		vbox.name = "vboxcontainer"
		input_dialog.add_child(vbox)
		
		var label = Label.new()
		label.text = "Scene Name:"
		vbox.add_child(label)
		
		var input_field = LineEdit.new()
		input_field.name = "InputField"
		vbox.add_child(input_field)
		
		var hbox = HBoxContainer.new()
		vbox.add_child(hbox)
		
		var ok_button = Button.new()
		ok_button.text = "OK"
		ok_button.connect("pressed", _on_dialog_ok)
		hbox.add_child(ok_button)
		
		var cancel_button = Button.new()
		cancel_button.text = "Cancel"
		cancel_button.connect("pressed", _on_dialog_cancel)
		hbox.add_child(cancel_button)
		
	input_dialog.popup_centered()
	input_dialog.get_node("vboxcontainer").get_node("InputField").clear()
	input_dialog.get_node("vboxcontainer").get_node("InputField").grab_focus()

func _on_dialog_ok():
	var input_field = input_dialog.get_node("vboxcontainer").get_node("InputField") as LineEdit
	var scene_name = input_field.text.strip_edges()
	if scene_name == "":
		return
	if selected_action == 0:
		_on_add_scene(scene_name)
	elif selected_action == 1:
		_on_rename_scene(scene_name)
	input_dialog.hide()

func _on_dialog_cancel():
	input_dialog.hide()

func _on_add_scene(scene_name: String):
	var item_icon = load(icons["scene"])
	add_item(scene_name, item_icon, true)
	Global.saveScene(UID.generate(), scene_name)
	print("ok")
	_refresh_scene_list()

func _on_delete_scene():
	var selected = get_selected_items()
	if selected.size() == 0:
		return
	var index = selected[0]
	var scene_keys = Global.project["scenes"].keys()
	if index < scene_keys.size():
		var scene_id = scene_keys[index]
		var scene = Global.project["scenes"][scene_id]
		if scene.has("name") and (scene["name"] == "main" or scene["name"] == "splash"):
			print("Cannot delete protected scene:", scene["name"])
			return
		Global.deleteScene(scene_id)
		_refresh_scene_list()

func _on_rename_scene(new_name: String):
	var selected = get_selected_items()
	if selected.size() == 0:
		return
	var index = selected[0]
	var scene_keys = Global.project["scenes"].keys()
	if index < scene_keys.size():
		var scene_id = scene_keys[index]
		var scene = Global.project["scenes"][scene_id]
		if scene.has("name") and (scene["name"] == "main" or scene["name"] == "splash"):
			print("Cannot rename protected scene:", scene["name"])
			return
		Global.project["scenes"][scene_id]["name"] = new_name
		_refresh_scene_list()

func _refresh_scene_list():
	clear()
	for scene_key in Global.project["scenes"].keys():
		var scene = Global.project["scenes"][scene_key]
		if typeof(scene) == TYPE_DICTIONARY and scene.has("name"):
			var item_icon = load(icons["scene"])
			add_item(scene["name"], item_icon)

func _on_scene_double_clicked(index: int) -> void:
	var scene_keys = Global.project["scenes"].keys()
	if index < scene_keys.size():
		var scene_id = scene_keys[index]
		Global.changeToScene(scene_id)
		print("Scene changed to:", scene_id)

func _on_mouse_entered():
	can_context_menu = true
func _on_mouse_exited():
	can_context_menu = false
