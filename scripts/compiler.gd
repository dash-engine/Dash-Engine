extends Node

var dir = "user://temp"
var temp = 1

@export var compiling_song : AudioStreamPlayer2D
@export var compiled_sound : AudioStreamPlayer2D
@export var error_sound : AudioStreamPlayer2D

var sceneSeparation = 1250

func compile():
	await close_gd()
	compiling_song.play()
	temp += 1
	Global.resetOutput()
	await Global.wait(0.5)
	Global.addToOutput("--- Start compiling ---", true)
	deleteTempDir()
	var current_scene = 1
	var objects_path = []
	create_spwn("global", Global.project["scripts"]["global"])
	duplicateCoreFiles()
	
	var objectsPos = {}
	var added_uids = {}
	
	var main_script = "" 
	var scr_head = """
					extract obj_props;
					extract import "imports.spwn";
					let scenesLib = import "scenes.spwn";
					//extract $;
					
					// GENERATED WITH GEOMETRY DASH GAME ENGINE
					let engineVersion = "1.0";
					Game.showWatermark();
					// Init game
					Game.init()
					"""
	
	var scenesLibCode = """
		let scenes = {
		"""
	
	var sceneCenterX = sceneSeparation
	var sceneCenterY = 700
	var mainCamGroup = Global.camGroup
	var sceneID = 0
	
	main_script += """
		camera.static_camera(%sg, duration=0);
	""" % mainCamGroup
	
	main_script += """
			$.add(obj {
				OBJ_ID: 60,
				X: %s,
				Y: %s,
				ROTATION: 0,
				GROUPS: %sg
			});
			%sg.alpha(0);
			Game.count_scene()
		""" % [sceneCenterX/1.42, sceneCenterY/1.5, mainCamGroup, mainCamGroup]
	
	for scene in Global.project["scenes"]:
		scene = Global.project["scenes"][scene]
		var centerX = sceneCenterX
		var centerY = sceneCenterY
		
		sceneID+=1
		
		var sceneUID = scene["uid"]
		
		var currentSceneGroup = scene["group"]
		var currentSceneNAME = scene["name"]
		
		scenesLibCode += """
		'%s':{'sceneGroup':%sg,'id':%s},
		""" % [currentSceneNAME,currentSceneGroup,sceneID]
		print("sdata ", scene)
		
		var scene_scale_x = 1
		var scene_scale_y = 1
		var offset_x = 0
		var offset_y = 0
		
		for object_id in Global.project["objects"]:
			var object = Global.project["objects"][object_id]
			if object["sceneUID"] != sceneUID:
				continue
			var uid = object["uid"]
			if uid in added_uids:
				continue
			added_uids[uid] = true
			
			var pos = Global.stringToVector2(object["position"])
			var rotation = object.get("rotation", 0.0)
			var type = object["type"]
			var objectGroup = object["group"]
			var DATA = object["DATA"]
			
			var centeredX = centerX - pos.x #centerX + (pos.x * scene_scale_x) + offset_x
			var centeredY = centerY - pos.y #centerY + (pos.y * scene_scale_y) + offset_y
			
			objectsPos[uid] = {"x": centeredX, "y": centeredY}
			print("DATA ",DATA)
			
			var moreArgs = ""
			
			if DATA.has("text"):
				print("textType")
				main_script += """
				/* Object: %s */
				%s.to_obj().with(X, %s).with(Y, %s).with(SCALING, %s).with(obj_props.GROUPS,[%s,%s,%s])
				""" % [uid, DATA["text"], centeredX, centeredY, Global.sceneGroup, currentSceneGroup, objectGroup]
			elif DATA.has("IMAGE"):
				gen_image(DATA.has("IMAGE"),DATA.has("IMAGE").replace("/","").replace("\\",""),Vector2(centeredX,centeredY))
			else:
				main_script += """
				/* Object: %s */
				$.add(obj {
					OBJ_ID: %s,
					X: %s,
					Y: %s,
					ROTATION: %s,
					%s
					GROUPS: [%sg, %sg, %sg]
				});
				""" % [uid, type, centeredX, centeredY, rotation, moreArgs, Global.sceneGroup, currentSceneGroup, objectGroup]
			
	for object_id in Global.project["objects"]:
		var object = Global.project["objects"][object_id]
		var uid = object["uid"]
		var position = objectsPos[uid]
		var rotation = object["rotation"]
		var group = object["group"]
		var script = Global.project["scripts"].get(uid, "")
		var compilingTimeScript = Global.project["compilingTimeScripts"].get(uid, "")
		var code = """
					extract obj_props;
					extract import "imports.spwn";
					extract $;
					let objectUID = "%s"
					let position = {x:%s, y:%s}
					let rotation = %s
					let this = %sg
					let objScene = counter(%s)
					// Object functions //
					set_transparency = (transparency) {
						this.alpha(transparency)
					}
					/////////////////////
					
					// The obj will not be shown at the starting
					//set_transparency(0)
					print("executing object: " + objectUID)
					/* --- Compiling script --- */
					%s
					/* ------------------------ */
					while_loop(() => objScene != Game.currentScene, (){
						wait(0.1)
					})
					set_transparency(1)
					execute = () {
					if objScene == Game.currentScene{
						/* Object script */
						%s
						/* ------------- */
					}
					};
					return {execute: execute};
		""" % [uid, position.x, position.y, rotation, group, sceneID, compilingTimeScript, script]
		objects_path.append(create_spwn("object_" + uid.replace("-", "_"), code))
	
	var final_script = ""
	for file in objects_path:
		final_script += """
		let %s = import "%s";\n
		""" % [file.replace(".spwn", ""), file]
		main_script += """
			%s.execute();
		""" % [file.replace(".spwn", "")]
	
	main_script += """\n10001g.move(10000000,0,100000)\n
	-> while_loop(() => true, () {
		wait(2)
	})
	"""
	
	final_script += main_script
	final_script = scr_head + "\n" + final_script
	create_spwn("main", final_script)
	
	scenesLibCode += """}
	return {scenes: scenes}"""
	create_spwn("scenes", scenesLibCode)
	
	await get_tree().create_timer(1).timeout
	var compileOutput = await compileCommand()
	print(compileOutput)
	if compileOutput.contains("Error comes from this macro call") or compileOutput.contains("Error when running this library/module") or compileOutput.contains("Error when parsing this library/module") or compileOutput.contains("you cannot add an obj type object at runtime"):
		Global.addToOutput("THERE WAS AN ERROR WHILE COMPILING!", true)
		error_sound.play()
	elif compileOutput.contains("Error reading level"):
		Global.addToOutput("""The level you're trying to change may be corrupted! This may be caused if Geometry Dash was forced closed or it crashed. to fix this error, you need to enter the level in geometry dash and then click "save and exit" """, true)
		error_sound.play()
	else:
		open_gd()
		compiled_sound.play()
	compiling_song.stop()
	Global.addToOutput("-- End compiling --", true)

func _ready() -> void:
	compile()

func create_spwn(fname, code):
	var fileName = fname + ".spwn"
	Global.addToOutput("Creating file: " + str(fileName), true)
	var file = FileAccess.open(dir + "/" + fileName, FileAccess.WRITE)
	file.store_string(code)
	file.close()
	return fileName

func gen_image(imgPath, imgName, position: Vector2):
	var script_path = "user://img.py"
	
	var file = FileAccess.open("res://utils/image/main.spwn",FileAccess.READ)
	var fileCode = ""
	while not file.eof_reached():
		fileCode += file.get_line()
		fileCode += "\n"
	file.close()
	fileCode = fileCode.replace("REPLACE_X",str(position.x))
	fileCode = fileCode.replace("REPLACE_Y",str(position.y))
	fileCode = fileCode.replace("REPLACE_FILE",imgName)
	
	if not FileAccess.file_exists(script_path):
		var res_file = FileAccess.open("res://utils/image/img.py", FileAccess.READ)
		var user_file = FileAccess.open(script_path, FileAccess.WRITE)
		user_file.store_string(res_file.get_as_text())
		res_file.close()
		user_file.close()
	
	var output = []
	var error_code = await OS.execute("python", [ProjectSettings.globalize_path(script_path), imgPath, imgName, ProjectSettings.globalize_path(dir)], output, true, true)

	Global.addToOutput(ansi_parser.parse(output[0]))

	if error_code != OK:
		print("exit with error: ", error_code)
	
	return create_spwn(imgName, fileCode)

func compileCommand():
	var filename = "main.spwn"
	
	var command = "spwn"
	var arguments = ["build", '"'+OS.get_user_data_dir()+"/temp/"+filename+'"', "--level-name", '"%s"' % Global.levelName]
	print("args: ",arguments)
	var output = []
	var error_code = await OS.execute(command, arguments, output, true, false)
	
	Global.addToOutput(ansi_parser.parse(output[0]))
	
	if error_code != OK:
		print("exit with error: ", error_code)
	return output[0]

func file_exist(fileName):
	var dir = DirAccess.open("user://")
	return dir.file_exists(fileName)

func deleteTempDir():
	var path = dir
	if !file_exist("temp"):
		DirAccess.make_dir_absolute(path)
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

func open_gd():
	var output = []
	
	Global.addToOutput("Opening gd...", true)
	
	OS.execute("cmd", ["/c", "start", "steam://run/322170"], output, false)

func close_gd():
	var output = []
	var error_code = 0
	
	Global.addToOutput("Closing gd...", true)
	
	OS.execute("tasklist", [], output, true, error_code)
	var is_running = false
	for line in output:
		if "GeometryDash.exe" in line:
			is_running = true
			break
	
	if is_running:
		OS.execute("taskkill", ["/F", "/IM", "GeometryDash.exe"], output, false)
		await get_tree().create_timer(2.0).timeout
