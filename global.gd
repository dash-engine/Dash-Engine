extends Node

var project = {
	"scripts": {"global":"""extract import "imports.spwn";
let example_variable = "hello world";
example_function = !{
	$.print("Hello world!")
}
return {
	example_variable: example_variable,
	example_function: example_function
}"""},
	"objects": {},
	"scenes": {},
	"files": {},
	"groups": []
}


const sceneGroup = 1001
const maxScenes = 1000
const maxObjects = 1000
const camGroup = 6000

var objectConainer = null

var current_selected_object = null

var output = ""
var outputRef = null

var projectName = "test"
var levelName = "test"

var currentScene = ""

var last_used_group = -1

func _ready() -> void:
	saveScene(UID.generate(),"main",sceneGroup)

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

func saveObject(uid, Name, position, type, rotation, sceneUID, group = -1):
	if group == -1:
		group = get_next_group()
	last_used_group = group
	project["objects"][uid] = {
		"uid": uid,
		"name": Name,
		"position": position,
		"rotation": rotation,
		"type": type,
		"sceneUID": sceneUID,
		"group": group,
	}

func saveScene(uid, Name, group = -1):
	if group == -1:
		group == randi_range(sceneGroup,sceneGroup+maxScenes)
		for scene in project["scenes"]:
			if group == project["scenes"][scene]["group"]:
				group == randi_range(sceneGroup,sceneGroup+maxScenes)
	
	project["scenes"][uid] = {
		"uid": uid,
		"name": Name,
		"group": group,
	}

func createFile():
	var Name = await get_string("File name")
	saveFile(UID.generate(),Name,"")

func saveFile(uid, Name, content):
	project["files"][uid] = {
		"uid": uid,
		"name": Name,
		"content": content,
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
		var group_to_delete = project["objects"][uid]["group"]
		project["groups"].erase(group_to_delete)
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

func get_string(question = ""):
	var clone = load("res://scenes/getString.tscn").instantiate()
	get_tree().root.add_child(clone)
	await clone.accepted == true
	print(clone.accepted)
	clone.queue_free()
	return clone.response

func get_next_group() -> int:
	if last_used_group == -1:
		last_used_group = 0
	else:
		last_used_group += 1
	
	if last_used_group not in project["groups"]:
		project["groups"].append(last_used_group)
	
	return last_used_group
