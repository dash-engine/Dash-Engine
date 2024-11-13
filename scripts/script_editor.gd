extends Control

@export var uid: String
@export var code: TextEdit
@export var Type = 1

func _ready() -> void:
	print("Script UID: ", uid)
	var scriptType = "scripts"
	if Type == 1:
		scriptType = "scripts"
	if Type == 2:
		scriptType = "compilingTimeScripts"
	if Global.project[scriptType].has(uid):
		code.text = Global.project[scriptType][uid]

func _on_close_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	Global.saveScript(uid, code.text, Type)
