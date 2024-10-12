extends Node

var dir = "user://temp"

var temp = 1

func compile():
	temp+=1
	Global.resetOutput()
	await Global.wait(.5)
	Global.addToOutput("---Start compiling---")
	deleteTempDir()
	var objectsPath = []
	create_spwn("global",Global.project["scripts"]["global"])
	duplicateCoreFiles()
	
	for object in Global.project["objects"]:
		object = Global.project["objects"][object]
		var uid = object["uid"]
		var Name = object["name"]
		var pos = object["position"]
		var rotation = object["rotation"]
		var type = object["type"]
		var script = Global.project["scripts"][uid]
		var code = """
//Imports
let Game = import "core.spwn"
let Global = import "global.spwn"

/// Object: %s ///
$.add(obj {{
	OBJ_ID: "%s",
	X: %f,
	Y: %f,
	ROTATION: %f,
	GROUPS: 1g
}});
/// Object script ///
%s
		""" % [Name, uid, pos.x, pos.y, rotation, script]
		objectsPath.append(create_spwn("object_"+uid.replace("-","_"),code))
	var code = """"""
	for file in objectsPath:
		code = """%s
%s""" % [code, 'let import "' + file + '"']
	create_spwn("main",code)
	compileCommand()
	Global.addToOutput("--end compiling--")

func _ready() -> void:
	compile()

func create_spwn(fname,code):
	var fileName = fname+".spwn"
	Global.addToOutput("Creating file" + str(fileName), true)
	var file = FileAccess.open(dir+"/"+fileName,FileAccess.WRITE)
	file.store_string(code)
	file.close()
	return fileName

func compileCommand():
	var filename = "main.spwn"
	var project_name = "project"
	
	var command = "spwn"
	var arguments = ["build", OS.get_user_data_dir()+"/temp/"+filename, "--level-name", '"test"']
	
	var output = []
	var error_code = OS.execute(command, arguments, output, true, true)
	
	Global.addToOutput(ansi_parser.parse(output[0]))
	
	if error_code != OK:
		print("exit with error: ", error_code)

func deleteTempDir():
	var path = dir
	var directory = DirAccess.open(path)
	if directory.get_open_error() == OK:
		directory.list_dir_begin() 
		var file_name = directory.get_next()
		while file_name != "":
			if file_name != "." and file_name != ".." and not directory.current_is_dir():
				var filePath = path + "/" + file_name
				if directory.remove(filePath) != OK:
					print("Failed to delete file: ", filePath)
			file_name = directory.get_next()
		directory.list_dir_end()
	else:
		print("Error opening directory: ", path)
	
	directory.list_dir_end()

func duplicateCoreFiles():
	var source_dir = "res://spwn/"
	var directory = DirAccess.open(source_dir)
	if directory.get_open_error() == OK:
		directory.list_dir_begin()
		var file_name = directory.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if directory.current_is_dir() == false:
					var new_file_path = dir + "/" + file_name
					var original_file_path = source_dir + file_name
					directory.copy(original_file_path, new_file_path)
			file_name = directory.get_next()
		directory.list_dir_end()
