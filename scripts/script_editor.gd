extends Control

@export var uid: String
@export var code: TextEdit

func _ready() -> void:
	if Global.project["scripts"].has(uid):
		print(Global.project["scripts"][uid])

func _on_close_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	Global.saveScript(uid, code.text)
