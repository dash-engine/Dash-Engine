extends TextEdit

var old = ""


func _process(delta: float) -> void:
	if old != Global.output:
		old = Global.output
		text = old
