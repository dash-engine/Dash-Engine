extends Control

@export var question: String
@export var response = ""
@export var textEdit: TextEdit

signal accepted

func _ready() -> void:
	textEdit.text = question
	textEdit.grab_focus()

func _on_accept_pressed() -> void:
	print("Accept")
	response = textEdit.text
	accepted.emit()
