extends Node

func save_data(content, fileName):
	var file = FileAccess.open("user://" + fileName,FileAccess.WRITE)
	file.store_string(content)
	file = null

func load_data(fileName:String):
	if !file_exist(fileName):
		return
	fileName = fileName.replace("user://","")
	var file = FileAccess.open("user://" + fileName,FileAccess.READ)
	var content = file.get_as_text()
	return content

func delete_data(fileName):
	var dir = DirAccess.open("user://")
	if dir.file_exists(fileName):
		dir.remove(fileName)

func file_exist(fileName):
	var dir = DirAccess.open("user://")
	return dir.file_exists(fileName)
