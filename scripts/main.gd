extends Control

@export var canvas : ColorRect

func _on_canvas_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		pass

func _on_button_pressed() -> void:
	add_object()

func add_object():
	var object = load("res://object.tscn")
	var clone = object.instantiate()
	canvas.add_child(clone)

func _on_compile_pressed() -> void:
	var clone = load("res://compiler.tscn").instantiate()
	add_child(clone)

func _on_edit_global_script_pressed() -> void:
	var clone = load("res://scenes/scriptEditor.tscn").instantiate()
	clone.uid = "global"
	get_tree().root.add_child(clone)
