extends Node

var function_map = [
	{
		"func": "create_object",
		"arguments": ["object_id", "x", "y", "rotation", "groups"],
		"command": """
$.add(obj {
	OBJ_ID: object_id,
	X: {x},
	Y: {y},
	ROTATION: {rotation},
	GROUPS: [{groups}]
});"""
	},
	{
		"func": "change_scene",
		"arguments": ["sceneUID"],
		"command": ""
	},
]

func parse_script(script_text: String) -> String:
	var lines = script_text.split("\n")
	var translated_script = ""
	
	for line in lines:
		line = line.strip_edges()
		if line == "" or line.begins_with("#"):
			translated_script += line + "\n"
			continue
		
		var parsed_line = parse_line(line)
		var command = parsed_line[0]
		var args_str = parsed_line[1]
		var translated_line = translate_command(command, args_str)
		translated_script += translated_line + "\n"

	return translated_script

func parse_line(line: String) -> Array:
	var parts = line.split("(", false)
	var command = parts[0].strip_edges()
	var args_str = ""
	
	if parts.size() > 1:
		args_str = parts[1].replace(")","")
	return [command, args_str]

func parse_arguments(args_str: String) -> Array:
	var args = args_str.split(",", false)
	for i in range(args.size()):
		args[i] = args[i].strip_edges()
	return args

func translate_command(command: String, args_str: String) -> String:
	for func_def in function_map:
		if func_def["func"] == command:
			var args = parse_arguments(args_str)
			if args.size() == func_def["arguments"].size():
				var finalCmd = func_def["command"]
				var NeedArgs = func_def["arguments"]
				var i = 0
				for arg in args:
					var argName = NeedArgs[i]
					finalCmd = finalCmd.replace("{" + argName + "}", arg)
					i += 1
				return finalCmd
			else:
				push_error("Invalid number of arguments for command: " + command)
				return command + "(" + args_str + ")"
	return command + "(" + args_str + ")"

func push_error(error_msg: String) -> void:
	print("Error: " + error_msg)
