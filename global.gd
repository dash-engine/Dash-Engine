extends Node

var project = {
	"scripts": {"global":""},
	"objects": {},
	"scenes": {},
}

var objectConainer = null

var current_selected_object = null

var output = ""
var outputRef = null

var projectName = "test"
var levelName = "test"

var currentScene = ""

func _ready() -> void:
	saveScene(UID.generate(),"main")

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

func saveObject(uid, Name, position, type, rotation, sceneUID):
	project["objects"][uid] = {
		"uid": uid,
		"name": Name,
		"position": position,
		"rotation": rotation,
		"type": type,
		"sceneUID": sceneUID
	}

func saveScene(uid, Name):
	project["scenes"][uid] = {
		"uid": uid,
		"name": Name
	}

func convertProjectToJson():
	var json = JSON.new()
	return json.stringify(project)

func wait(sec):
	return await get_tree().create_timer(sec).timeout

func saveProject():
	var projectJson = convertProjectToJson()
	Data.save_data(projectJson,projectName)

func loadProject(projectName):
	var projectData = Data.load_data(projectName)

func deleteObject(uid):
	if uid in project["objects"]:
		current_selected_object = null
		if objectConainer:
			objectConainer.get_node(uid).queue_free()
		project["objects"].erase(uid)
	else:
		print("No object found with uid: ", uid)

func deleteScene(uid):
	if uid in project["scenes"]:
		project["scenes"].erase(uid)
	else:
		print("No scene found with uid: ", uid)
