extends Control

@export var nameTextBox : TextEdit
@export var uidTextBox : TextEdit
@export var editScriptButton : Button
@export_group("ObjType")
@export var objTypeBox : OptionButton

var oldSelected = null

func _process(delta: float) -> void:
	if Global.current_selected_object:
		uidTextBox.text = Global.current_selected_object.uid
	if oldSelected != Global.current_selected_object:
		oldSelected = Global.current_selected_object
		var type = Objects.get_index_by_id(Global.current_selected_object.type)
		if type > 0:
			objTypeBox.selected = type

func _on_edit_script_pressed() -> void:
	if Global.current_selected_object:
		var clone = load("res://scenes/scriptEditor.tscn").instantiate()
		clone.uid = Global.current_selected_object.uid
		get_tree().root.add_child(clone)

func _on_obj_type_item_selected(index: int) -> void:
	if Global.current_selected_object:
		Global.current_selected_object.type = Objects.get_type(index)
		Global.project["objects"][Global.current_selected_object.uid]["type"] = Objects.get_type(index)
