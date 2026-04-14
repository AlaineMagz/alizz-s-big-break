@tool
class_name Entity extends GameObject

@export_group("Entity")
@export var cb2d : CharacterBody2D

@export_group("Entity Nodes")
@export var levelManager: Node2D
@export var currentFloor : Node2D

@export_group("Entity Visual")
@export var sprite : Sprite2D
@export var xOffset : float = 0:
	set(value):
			xOffset = value
			queue_redraw()

@export var yOffset : float = 0:
	set(value):
			yOffset = value
			queue_redraw()

@export var zOffset : float = 0:
	set(value):
		zOffset = value
		queue_redraw()

@export_group("Entity Stat Variables")
@export var speed : int = 10
@export var fallSpeed : int = 10
@export var jumpPower : int = 20

@export_group("Entity State Variables")
@export var isJumping : bool = false
@export var isFalling : bool = false
@export var yVelocity : int = 0

func handle_floor():
	
	var floorFound = false
	
	for fl : Geometry in levelManager.floorM.floorArr:
		
		var inBounds = false
		var sameYLevel = false
		
		if fl.get_top_pos() == get_bottom_pos():
			sameYLevel = true
		else: if get_bottom_pos() > fl.get_top_pos() && (get_bottom_pos() - fl.get_top_pos()) < fallSpeed:
			objectPos.y = fl.get_top_pos() - yBounds.x
			sameYLevel = true
		
		if (get_right_pos() > fl.get_left_pos() && get_left_pos() < fl.get_right_pos()) && (get_back_pos() > fl.get_front_pos() && get_front_pos() < fl.get_back_pos()):
			inBounds = true
		
		if inBounds && sameYLevel:
			currentFloor = fl
			floorFound = true
			print(fl.name)
		
	
	if !floorFound:
		currentFloor = null
	

func handle_wall():
	
	pass
	

func handle_vertical(delta):
	
	if currentFloor == null:
		isFalling = true
	else:
		isFalling = false
	
	if isJumping:
		isFalling = false
		
		if yVelocity > 0:
			
			objectPos.y += yVelocity
			yVelocity -= fallSpeed * delta
			
		else:
			isJumping = false
			isFalling = true
		
	
	if isFalling:
		objectPos.y -= fallSpeed
	

func _draw():
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
