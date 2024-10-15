extends ItemList

var icons = {
	"textFile" = "res://assets/img/textFile.png"
}

@export var context_menu : PopupMenu

var can_context_menu = false

# TODO: Make file manager work

func _on_popup_menu_id_pressed(id: int) -> void:
	if id == 0:
		var item = load(icons["textFile"])
		self.add_item("file.txt", item, true)
		Global.createFile()
	if id == 1:
		var item = load(icons["textFile"])
		self.add_item("scene", item, true)
	if id == 2:
		pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			if can_context_menu:
				context_menu.visible = true
				context_menu.position = get_global_mouse_position()

func _on_mouse_entered():
	can_context_menu = true

func _on_mouse_exited():
	can_context_menu = false
