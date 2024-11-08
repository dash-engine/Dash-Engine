extends Node

var OBJECTS_IDS = [
	{
		"id": 1,
		"block": "block"
	},
	{
		"id": 8,
		"block": "spike"
	},
	{
		"id": 1816,
		"block": "COLLISION_BLOCK"
	}
]

func get_type(index):
	return OBJECTS_IDS[index]["id"]

func get_object_name(index):
	return OBJECTS_IDS[index]["block"]

func get_index_by_id(object_id):
	for i in range(len(OBJECTS_IDS)):
		if OBJECTS_IDS[i]["id"] == object_id:
			return i
	return -1
