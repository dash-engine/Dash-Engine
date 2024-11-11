extends Control

@onready var scene_list : ItemList = $VBoxContainer/ItemList
@onready var scene_name_input : LineEdit = $VBoxContainer/LineEdit
@onready var add_button : Button = $VBoxContainer/AddButton
@onready var delete_button : Button = $VBoxContainer/DeleteButton
@onready var rename_button : Button = $VBoxContainer/RenameButton

func _ready():
	add_button.pressed.connect(_on_add_scene)
	delete_button.pressed.connect(_on_delete_scene)
	rename_button.pressed.connect(_on_rename_scene)

	_refresh_scene_list()

func _on_add_scene():
	var scene_name = scene_name_input.text.strip_edges()
	if scene_name == "":
		return
	Global.saveScene(UID.generate(),scene_name,)
	_refresh_scene_list()
	scene_name_input.clear()

func _on_delete_scene():
	var selected = scene_list.get_selected_items()
	if selected.size() == 0:
		return
	var index = selected[0]
	print(index)
	#Global.deleteScene()
	_refresh_scene_list()

func _on_rename_scene():
	var selected = scene_list.get_selected_items()
	if selected.size() == 0:
		return
	var index = selected[0]
	var new_name = scene_name_input.text.strip_edges()
	if new_name == "":
		return
	Global.project["scenes"][index]["name"] = new_name
	_refresh_scene_list()
	scene_name_input.clear()

func _refresh_scene_list():
	scene_list.clear()
	for scene in Global.project["scenes"]:
		scene_list.add_item(scene["name"])
