extends Panel

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

var alrPressed = false
var pressedDebounce = false

const GRID_SIZE = 8

func _ready() -> void:
	uid = UID.generate()
	Global.saveObject(uid, Name, Position, type, Rotation)
	Global.saveScript(uid, "")
	if canvas == null:
		if get_parent():
			if get_parent().is_class("Control"):
				canvas = get_parent()
	canvas_rect = Rect2(canvas.position - Vector2(146, 32), canvas.size)

func pressed():
	if pressedDebounce == false:
		pressedDebounce = true
		Global.current_selected_object = self

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				alrPressed = true
				drag_offset = get_global_mouse_position() - position
			else:
				pressedDebounce = false
				alrPressed = false
				dragging = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				pass
			else:
				pass

func _process(delta):
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

func getSprite():
	var spritesFolder = "res://assets/sprites/obj/"
	var objSprite = spritesFolder + Objects.get_object_name(Objects.get_index_by_id(type)) + ".png"
	Sprite.texture = load(objSprite)
