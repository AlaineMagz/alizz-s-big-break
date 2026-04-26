@tool
class_name GameObject extends Node2D

enum ObjectTypes{ Geometry, Entity, Item, Area }

@export var objectType: ObjectTypes

@export_group("Bounds")
@export var objectPos : Vector3 = Vector3(0,0,0):
	set(value):
		objectPos = value
		queue_redraw()

@export var xBounds : Vector2 = Vector2(0,0):
	set(value):
			xBounds = value
			queue_redraw()

@export var yBounds : Vector2 = Vector2(0,0):
	set(value):
			yBounds  = value
			queue_redraw()

@export var zBounds : Vector2 = Vector2(0,0):
	set(value):
			zBounds = value
			queue_redraw()

@export_group("Visual")
@export var drawDebug: bool = false:
	set(value):
		drawDebug = value
		queue_redraw()

@export var debugColor: Color = Color.WHITE:
	set(value):
		debugColor = value
		queue_redraw()

@export var debugOutlineColor: Color = Color.BLACK:
	set(value):
		debugOutlineColor = value
		queue_redraw()

@export var debugOutlineWeight: int = 5:
	set(value):
		debugOutlineWeight = value
		queue_redraw()

@export_group("Debug Tools")

@export_tool_button("Print Top Position") 
var top_pos_button : Callable = func() -> void : print(get_top_pos())

@export_tool_button("Print Bottom Position") 
var bottom_pos_button : Callable = func() -> void : print(get_bottom_pos())

@export_tool_button("Print Front Position") 
var front_pos_button : Callable = func() -> void : print(get_front_pos())

@export_tool_button("Print Back Position") 
var back_pos_button : Callable = func() -> void : print(get_back_pos())

@export_tool_button("Print Left Position") 
var left_pos_button : Callable = func() -> void : print(get_left_pos())

@export_tool_button("Print Right Position") 
var right_pos_button : Callable = func() -> void : print(get_right_pos())

func _process(_delta : float) -> void:
	
	if Engine.is_editor_hint():
		calculate_2D_position()
		queue_redraw()
	

func calculate_2D_position() -> void:
	
	position = Vector2(objectPos.x + (objectPos.z) / 2, -(objectPos.y + (objectPos.z / 2)))
	

func get_2D_position(objPos : Vector3) -> Vector2:
	
	return Vector2(objPos.x + (objPos.z) / 2, -(objPos.y + (objPos.z / 2)))
	

func get_front_pos() -> float:
	return objectPos.z + zBounds.x

func get_back_pos() -> float:
	return objectPos.z + zBounds.y

func get_top_pos() -> float:
	return objectPos.y + yBounds.y

func get_bottom_pos() -> float:
	return objectPos.y + yBounds.x

func get_left_pos() -> float:
	return objectPos.x + xBounds.x

func get_right_pos() -> float:
	return objectPos.x + xBounds.y

func is_overlapping_vertically(obj1 : GameObject, obj2 : GameObject) -> bool:
	
	var hPadding : float = 0.5
	
	if obj1.get_front_pos() + hPadding >= obj2.get_back_pos() || obj1.get_back_pos() - hPadding <= obj2.get_front_pos():
		return false
	
	if obj1.get_bottom_pos() >= obj2.get_top_pos() || obj1.get_top_pos() <= obj2.get_bottom_pos():
		return false
	
	if obj1.get_left_pos() + hPadding >= obj2.get_right_pos() || obj1.get_right_pos() - hPadding <= obj2.get_left_pos():
		return false
	
	return true
	

func is_overlapping_horizontally(obj1 : GameObject, obj2 : GameObject) -> bool:
	
	var vPadding : float = 0.5
	
	if obj1.get_front_pos() >= obj2.get_back_pos() || obj1.get_back_pos() <= obj2.get_front_pos():
		return false
	
	if obj1.get_bottom_pos() + vPadding >= obj2.get_top_pos() || obj1.get_top_pos() - vPadding <= obj2.get_bottom_pos():
		return false
	
	if obj1.get_left_pos() >= obj2.get_right_pos() || obj1.get_right_pos() <= obj2.get_left_pos():
		return false
	
	return true
	

#Draw Functions
func getFrontFacePoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var bottomLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var topLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	
	var frontFace : PackedVector2Array
	frontFace.append(topLeft)
	frontFace.append(topRight)
	frontFace.append(bottomRight)
	frontFace.append(bottomLeft)
	
	return frontFace

func getFrontFaceBorderPoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var bottomLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var topLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	
	var frontFaceBorder : PackedVector2Array
	frontFaceBorder.append(topLeft)
	frontFaceBorder.append(topRight)
	frontFaceBorder.append(bottomRight)
	frontFaceBorder.append(bottomLeft)
	frontFaceBorder.append(topLeft)
	
	return frontFaceBorder

func getSideFacePoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var topLeft : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	var bottomLeft : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.x + (zBound.y / 2)))
	
	var sideFace : PackedVector2Array
	sideFace.append(topLeft)
	sideFace.append(topRight)
	sideFace.append(bottomRight)
	sideFace.append(bottomLeft)
	
	return sideFace

func getSideFaceBorderPoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var topLeft : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	var bottomLeft : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.x + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.x + (zBound.y / 2)))
	
	var sideFaceBorder : PackedVector2Array
	sideFaceBorder.append(topLeft)
	sideFaceBorder.append(topRight)
	sideFaceBorder.append(bottomRight)
	sideFaceBorder.append(bottomLeft)
	sideFaceBorder.append(topLeft)
	
	return sideFaceBorder

func getTopFacePoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var bottomLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topLeft : Vector2 = Vector2(xBound.x + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	
	var topFace : PackedVector2Array
	topFace.append(topLeft)
	topFace.append(topRight)
	topFace.append(bottomRight)
	topFace.append(bottomLeft)
	
	return topFace

func getTopFaceBorderPoints(xBound:Vector2, yBound:Vector2, zBound:Vector2) -> PackedVector2Array:
	var bottomLeft : Vector2 = Vector2(xBound.x + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var bottomRight : Vector2 = Vector2(xBound.y + (zBound.x / 2), -(yBound.y + (zBound.x / 2)))
	var topLeft : Vector2 = Vector2(xBound.x + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	var topRight : Vector2 = Vector2(xBound.y + (zBound.y / 2), -(yBound.y + (zBound.y / 2)))
	
	var topFaceBorder : PackedVector2Array
	topFaceBorder.append(topLeft)
	topFaceBorder.append(topRight)
	topFaceBorder.append(bottomRight)
	topFaceBorder.append(bottomLeft)
	topFaceBorder.append(topLeft)
	
	return topFaceBorder
