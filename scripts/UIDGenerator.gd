extends Node

func generate() -> String:
	var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var uid = ""
	
	for i in range(12):
		var random_char = characters[int(randf() * characters.length())]
		uid += random_char
		if i == 3 or i == 7:
			uid += "-"
	
	return uid
