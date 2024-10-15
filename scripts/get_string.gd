extends Control

@export var question : String

@export var response = ""

@export var textEdit : TextEdit

signal accepted

# FIXME: For some reason, you cant type on the textbox

func _process(delta: float) -> void:
	textEdit.text = question

func _on_accept_pressed() -> void:
	response = textEdit.text
	accepted.emit()
