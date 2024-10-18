extends Node

var project = {
	"scripts": {"global":"""let example_variable = "hello world";
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

var mainScene = null

var projectName = "test"
var levelName = "test"

var currentScene = ""

var last_used_group = -1

func _ready() -> void:
	mainScene = get_tree().root.get_node("main")
	checkForSpwn()
	saveScene(UID.generate(),"main",sceneGroup)

func checkForSpwn():
	var spwnoutput = []
	var error_code = OS.execute("spwn", [], spwnoutput, true, false)
	if spwnoutput[0].contains("SPWN code"):
		print("SPWN installed!")
	else:
		OS.shell_open("https://github.com/Spu7Nix/SPWN-language/releases/tag/v0.8-beta")
		get_tree().quit()
		print("SPWN not installed!")

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
	var files = {}
	var canContinue = true
	for file in project["files"]:
		if file["name"] == Name:
			canContinue = false
			createFile()
			break
	if canContinue:
		saveFile(UID.generate(),Name,"")

func get_string(question = ""):
	var clone = await mainScene.get_string() #load("res://scenes/getString.tscn").instantiate()
	return clone
	clone.question = question
	#get_tree().root.add_child(clone)
	await clone.accepted == true
	print(clone.accepted)
	clone.queue_free()
	return clone.response

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
	if !Data.file_exist("projects"):
		DirAccess.make_dir_absolute("user://projects")
	Data.save_data(projectJson,"projects/"+projectName)
	print("saving project to ", "projects/"+projectName)

func loadProject(projectName):
	var fileDialog = FileDialog.new()
	fileDialog.position = Vector2(250,100)
	fileDialog.size = Vector2(600,400)
	fileDialog.access = FileDialog.ACCESS_USERDATA
	fileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fileDialog.root_subfolder = "projects"
	fileDialog.visible = true
	get_tree().root.add_child(fileDialog)
	fileDialog.file_selected.connect(loadProjFile)

func loadProjFile(Path):
	var json = JSON.new()
	var projectData = json.parse(Data.load_data(Path))
	if projectData == OK:
		projectData = json.get_data()
	else:
		return
	
	for object in objectConainer.get_children():
		object.queue_free()
	
	for object in projectData["objects"]:
		object = projectData["objects"][object]
		var newObj = mainScene.add_object(true)
		newObj.uid = object["uid"]
		newObj.Name = object["name"]
		newObj.position = stringToVector2(object["position"])
		newObj.rotation = object["rotation"]
		newObj.type = object["type"]
		newObj.group = object["group"]
	project = Dictionary(projectData)

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

func get_next_group() -> int:
	if last_used_group == -1:
		last_used_group = 1
	else:
		last_used_group += 1
	
	if last_used_group not in project["groups"]:
		project["groups"].append(last_used_group)
	
	return last_used_group

func stringToVector2(coords: String) -> Vector2:
	coords = coords.replace("(", "").replace(")", "")
	
	var coordinates := coords.split(",")
	var x := int(coordinates[0])
	var y := int(coordinates[1])
	
	var vector2 := Vector2(x, y)
	return vector2
