extends Control

@export var nameTextBox : TextEdit
@export var uidTextBox : TextEdit
@export var groupTextBox : TextEdit
@export var editScriptButton : Button
@export var textTextBox : TextEdit
@export_group("ObjType")
@export var objTypeBox : OptionButton

var oldSelected = null
var updateProperties = false
var oldObjText = ""

func _process(delta: float) -> void:
	if Global.current_selected_object:
		uidTextBox.text = Global.current_selected_object.uid
		groupTextBox.text = "Group: " + str(Global.current_selected_object.group) + "g"
	if oldSelected != Global.current_selected_object or updateProperties:
		oldSelected = Global.current_selected_object
		if not Global.current_selected_object:
			return
		var type = Objects.get_index_by_id(Global.current_selected_object.type)
		if type > -1:
			objTypeBox.selected = type
		textTextBox.visible = type == 2
		await Global.wait(0.1)
		checkTextBox()

func _on_obj_type_item_selected(index: int) -> void:
	if Global.current_selected_object:
		Global.current_selected_object.type = Objects.get_type(index)
		Global.project["objects"][Global.current_selected_object.uid]["type"] = Objects.get_type(index)
		updateProperties = true
		await Global.wait(0)
		updateProperties = false

func _on_delete_pressed() -> void:
	if Global.current_selected_object:
		Global.deleteObject(Global.current_selected_object.uid)

func _on_edit_compilingtime_script_pressed() -> void:
	if Global.current_selected_object:
		var clone = load("res://scenes/scriptEditor.tscn").instantiate()
		clone.Type = 2
		clone.uid = Global.current_selected_object.uid
		get_tree().root.add_child(clone)

func _on_edit_script_pressed() -> void:
	if Global.current_selected_object:
		var clone = load("res://scenes/scriptEditor.tscn").instantiate()
		clone.Type = 1
		clone.uid = Global.current_selected_object.uid
		get_tree().root.add_child(clone)

func checkTextBox():
	if textTextBox.text == "" or textTextBox.text == " ":
		textTextBox.text = "A"
	if textTextBox.text.length() > 20:
		textTextBox.text = oldObjText
	oldObjText = textTextBox.text

func _on_text_text_changed() -> void:
	checkTextBox()
	Global.current_selected_object.DATA["text"] = textTextBox.text
