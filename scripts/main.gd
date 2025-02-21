extends Control

@export var canvas : ColorRect

func _ready() -> void:
	Global.objectConainer = canvas

func _on_canvas_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		pass

func _on_button_pressed() -> void:
	add_object()

func add_object(custom_object = false, collider = false):
	var object = load("res://object.tscn")
	var clone = object.instantiate()
	clone.initializate = !custom_object
	clone.collider = collider
	canvas.add_child(clone)
	return clone

func _on_compile_pressed() -> void:
	var clone = load("res://compiler.tscn").instantiate()
	add_child(clone)

func _on_edit_global_script_pressed() -> void:
	var clone = load("res://scenes/scriptEditor.tscn").instantiate()
	clone.uid = "global"
	get_tree().root.add_child(clone)

func _on_save_button_pressed() -> void:
	Global.saveProject()

func _on_load_button_pressed() -> void:
	Global.loadProject("test")

func get_string(question = ""):
	var clone = load("res://scenes/getString.tscn").instantiate()
	clone.question = question
	self.add_child(clone)
	await clone.accepted == true
	print(clone.accepted)
	clone.queue_free()
	return clone.response

func _on_add_collider_pressed() -> void:
	add_object(false,true)

func refresh_scene_list():
	$fileManager._refresh_scene_list()
