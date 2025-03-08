extends Panel
#### Constants ####
const GRID_SIZE = 8
###################

@export var canvas : Control
@export var Sprite : Sprite2D

@export var canvas_rect : Rect2
@export var dragging = false
@export var drag_offset = Vector2()

@export var Name : String
@export var Position = Vector2()
@export var Rotation = 0.0

@export var uid : String

@export var type = 1

@export var group = -1

@export var collider = false

@export var initializate = false

@export var DATA = {}

var alrPressed = false
var pressedDebounce = false

@onready var oldType = type

func _ready() -> void:
	if initializate:
		if collider:
			DATA["COLLIDER_GROUP"] = Global.get_next_group()
			type = 1816
		uid = UID.generate()
		Global.saveObject(uid, Name, Position, type, Rotation, Global.currentScene,DATA)
		Global.saveScript(uid,"/* This script is ran at runtime, this means all the code here will be executed ingame, you can delete this comment */",1)
		Global.saveScript(uid,"/* This script is ran at compile-time, this means all the code here will be executed when compiling the game.\nNote: THIS SCRIPT WILL BE RUN EVEN IF YOU ARE NOT IN THE SCENE!\nYou can delete this comment */",2)
		group = Global.project["objects"][uid]["group"]
	name = uid
	if canvas == null:
		if get_parent():
			if get_parent().is_class("Control"):
				canvas = get_parent()
	canvas_rect = Rect2(Vector2(0, 0), canvas.size)
	if collider:
		Sprite.texture = load("res://assets/sprites/collider.png")

func pressed():
	if pressedDebounce == false:
		pressedDebounce = true
		Global.current_selected_object = self

func IExist():
	if not Global.project["objects"].has(uid):
		queue_free()
		return false
	return true

func _gui_input(event):
	if not IExist(): return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				alrPressed = true
				drag_offset = get_global_mouse_position() - position
			else:
				Global.project["objects"][uid]["position"] = position
				pressedDebounce = false
				alrPressed = false
				dragging = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				pass
			else:
				pass

func _process(delta):
	if not IExist(): return
	if oldType != type:
		oldType = type
		getSprite()
	if dragging:
		var new_position = get_global_mouse_position() - drag_offset
		
		new_position.x = clamp(new_position.x, canvas_rect.position.x, canvas_rect.position.x + canvas_rect.size.x - size.x)
		new_position.y = clamp(new_position.y, canvas_rect.position.y, canvas_rect.position.y + canvas_rect.size.y - size.y)
		
		new_position.x = round(new_position.x / GRID_SIZE) * GRID_SIZE
		new_position.y = round(new_position.y / GRID_SIZE) * GRID_SIZE
		
		position = new_position
	if alrPressed:
		pressed()
	if type == 912:
		Sprite.visible = false
		if DATA.has("text"):
			if $Text.text != DATA["text"]:
				$Text.text = DATA["text"]
				print("UPDATE ",DATA["text"])
				print(DATA)
		else:
			DATA["text"] = "A"
		$Text.position = Vector2(lerp(0, -128, $Text.text.length() / 20), 0)
	else:
		Sprite.visible = true
		$Text.text = ""
	Global.project["objects"][uid]["DATA"] = DATA

func getSprite():
	if collider:
		return
	var spritesFolder = "res://assets/sprites/obj/"
	var objSprite = spritesFolder + Objects.get_object_name(Objects.get_index_by_id(type)) + ".png"
	Sprite.texture = load(objSprite)
