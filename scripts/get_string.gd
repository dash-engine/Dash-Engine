extends Control

@export var question: String
@export var response = ""
@export var textEdit: TextEdit

signal accepted

# FIXME: For some reason it wont get the input, please fix

func _ready() -> void:
	textEdit.text = question

func _on_accept_pressed() -> void:
	print("Accept")
	response = textEdit.text
	accepted.emit()
