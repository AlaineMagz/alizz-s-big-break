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
@export var isGrounded : bool = false
@export var yVelocity : int = 0

func handle_floor() -> void:
	
	var floorFound : bool = false
	
	for fl : Geometry in levelManager.floorM.floorArr:
		
		var inBounds : bool = false
		var sameYLevel : bool = false
		
		if currentFloor == null:
			if fl.get_top_pos() == get_bottom_pos():
				sameYLevel = true
			else: if get_bottom_pos() > fl.get_top_pos() && (get_bottom_pos() - fl.get_top_pos()) < fallSpeed:
				objectPos.y = fl.get_top_pos() - yBounds.x
				yVelocity = 0
				sameYLevel = true
			
			if (get_right_pos() > fl.get_left_pos() && get_left_pos() < fl.get_right_pos()) && (get_back_pos() > fl.get_front_pos() && get_front_pos() < fl.get_back_pos()):
				inBounds = true
			
			if inBounds && sameYLevel:
				currentFloor = fl
				floorFound = true
				isGrounded = true
				print("SET FLOOR TO " + currentFloor.name)
		
	
	if !floorFound:
		currentFloor = null
		isGrounded = false
	

func handle_wall() -> void:
	
	pass
	

func handle_vertical(delta : float) -> void:
	
	if !isGrounded:
		isFalling = true
	else:
		isFalling = false
		isJumping = false
		yVelocity = 0
	
	if isJumping:
		isFalling = false
		
		if yVelocity > 0:
			
			objectPos.y += yVelocity
			yVelocity -= fallSpeed * delta
			
		else:
			isJumping = false
			isFalling = true
		
	
	if isFalling:
		yVelocity -= max(1, fallSpeed * delta)
		objectPos.y += yVelocity
	

func _draw() -> void:
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
