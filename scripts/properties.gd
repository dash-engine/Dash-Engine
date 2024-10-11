extends Control

@export var nameTextBox : TextEdit
@export var uidTextBox : TextEdit
@export var editScriptButton : Button
@export_group("ObjType")
@export var objTypeBox : OptionButton

func _process(delta: float) -> void:
	if Global.current_selected_object:
		uidTextBox.text = Global.current_selected_object.uid

func _on_edit_script_pressed() -> void:
	if Global.current_selected_object:
		var clone = load("res://scenes/scriptEditor.tscn").instantiate()
		clone.uid = Global.current_selected_object.uid
		get_tree().root.add_child(clone)
