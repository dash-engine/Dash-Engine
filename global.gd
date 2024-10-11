extends Node

var project = {
	"scripts": {"global":""},
	"objects": {} 
}

var current_selected_object = null

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
