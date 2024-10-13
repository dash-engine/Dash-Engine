extends Node

var dir = "user://temp"
var temp = 1

const scene_group = 500

func compile():
	temp += 1
	Global.resetOutput()
	await Global.wait(0.5)
	Global.addToOutput("--- Start compiling ---",true)
	deleteTempDir()
	var current_scene = 1
	var objects_path = []
	create_spwn("global", Global.project["scripts"]["global"])
	duplicateCoreFiles()
	
	var main_script = """
					extract obj_props;
					// GENERATED WITH GEOMETRY DASH GAME ENGINE
					let engineVersion = "1.0";
					let Game = import "core.spwn";
					Game.showWatermark();
					"""

	for object_id in Global.project["objects"]:
		var object = Global.project["objects"][object_id]
		var uid = object["uid"]
		var script = Global.project["scripts"].get(uid, "")
		var code = """
					extract obj_props;
					let Game = import "core.spwn";
					let Global = import "global.spwn";
					execute = (){
					/* Object script */
					%s
					};
					return {execute: execute};
		""" % script
		objects_path.append(create_spwn("object_" + uid.replace("-", "_"), code))
	
	for file in objects_path:
		print(file)
		main_script += """let %s = import "%s";\n""" % [file.replace(".spwn", ""), file]

	for object_id in Global.project["objects"]:
		var object = Global.project["objects"][object_id]
		var uid = object["uid"]
		var pos = object["position"]
		var rotation = object.get("rotation", 0.0)
		var type = object["type"]

		main_script += """
		/* Object: %s */
		$.add(obj {
			OBJ_ID: %s,
			X: %s,
			Y: %s,
			ROTATION: %s,
			GROUPS: [%sg, %sg]
		});
		object_%s.execute();\n""" % [uid, type, pos.x, pos.y, rotation, scene_group, current_scene, uid.replace("-", "_")]
	create_spwn("main", main_script)
	compileCommand()
	print(main_script)
	Global.addToOutput("-- End compiling --",true)

func _ready() -> void:
	compile()

func create_spwn(fname, code):
	var fileName = fname + ".spwn"
	Global.addToOutput("Creating file: " + str(fileName), true)
	var file = FileAccess.open(dir + "/" + fileName, FileAccess.WRITE)
	file.store_string(code)
	file.close()
	return fileName

func compileCommand():
	var filename = "main.spwn"
	
	var command = "spwn"
	var arguments = ["build", OS.get_user_data_dir()+"/temp/"+filename, "--level-name", '"%s"' % Global.levelName]
	
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

func duplicateCoreFiles():
	var source_dir = "res://spwn/"
	var directory = DirAccess.open(source_dir)

	if directory.get_open_error() == OK:
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if not directory.current_is_dir():
					var new_file_path = dir + "/" + file_name
					var original_file_path = source_dir + file_name
					directory.copy(original_file_path, new_file_path)
			file_name = directory.get_next()

		directory.list_dir_end()
