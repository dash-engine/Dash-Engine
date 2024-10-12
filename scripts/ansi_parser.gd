extends Node

## If it works it works 👍
## I've been trying to make this work for 1 hour

func parse(input: String) -> String:
	var output = ""
	var split_lines = input.split("\n")
	for line in split_lines:
		var parts = line.split("")
		for part in parts:
			if part == "":
				continue
			var code_parts = part.split("m")
			if code_parts.size() > 1:
				var code = code_parts[0]
				var txt = "" 
				for i in range(1, code_parts.size()):
					txt += code_parts[i]
				if txt != "":
					output += txt
			else:
				output += part
		output += "\n"
	output = output.replace("â€”", "—")
	return output
