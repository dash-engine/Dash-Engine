extends Control

@export var uid: String
@export var code: TextEdit

func _ready() -> void:
	print("Script UID: ", uid)
	if Global.project["scripts"].has(uid):
		code.text = Global.project["scripts"][uid]

func _on_close_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	Global.saveScript(uid, code.text)
