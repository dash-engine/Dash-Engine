extends Node

var project = {
	"scripts": {"global":""},
	"objects": {} 
}

var current_selected_object = null

var output = ""
var outputRef = null

func resetOutput():
	toggleOutput(false)
	output = ""
	toggleOutput(true)

func addToOutput(text, print = false):
	output = output + "\n" + str(text)
	if print:
		print_rich(text)

func toggleOutput(create = outputRef == null):
	if create:
		var clone = load("res://scenes/output.tscn").instantiate()
		get_tree().root.add_child(clone)
		outputRef = clone
	else:
		if outputRef:
			outputRef.queue_free()
			outputRef = null

func saveScript(uid, code):
	project["scripts"][uid] = code

func saveObject(uid, Name, position, type, rotation):
	project["objects"][uid] = {
		"uid": uid,
		"name": Name,
		"position": position,
		"rotation": rotation,
		"type": type
	}

func convertProjectToJson():
	var json = JSON.new()
	return json.stringify(project)

func wait(sec):
	return await get_tree().create_timer(sec).timeout
