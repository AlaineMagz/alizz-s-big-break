@tool
class_name Entity extends GameObject

@export_group("Entity")
@export var cb2d : CharacterBody2D

@export_group("Entity Nodes")
@export var levelManager: Node2D
@export var currentFloor : Geometry

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
@export var speed : float = 10
@export var sprintSpeed : float = 20
@export var fallSpeed : float = 10
@export var terminalVelocity : float = 30
@export var jumpPower : float = 20

@export_group("Entity State Variables")
@export var isSprinting : bool = false
@export var startedJump : bool = false
@export var isJumping : bool = false
@export var isFalling : bool = false
@export var isGrounded : bool = false
@export var yVelocity : float = 0

func handle_physics(delta : float) -> void:
	
	handle_collission()
	
	if isGrounded:
		yVelocity = 0
	else:
		yVelocity -= fallSpeed * delta
	
	if -yVelocity > terminalVelocity:
		yVelocity = -terminalVelocity
	
	if yVelocity > 0:
		isJumping = true
		isFalling = false
	else: if yVelocity < 0:
		isFalling = true
		isJumping = false
	else:
		isFalling = false
		isJumping = false
	
	objectPos.y += yVelocity
	
	calculate_2D_position()
	

func handle_collission() -> void:
	
	var done : bool = false
	
	for geometry : Geometry in levelManager.geometry_list:
		
		if is_overlapping(self, geometry) && !done:
			currentFloor = geometry
			done = true
		
	
	if !done:
		currentFloor = null
		isGrounded = false
	
	if currentFloor != null && !isGrounded && isFalling:
		objectPos.y = currentFloor.get_top_pos() - yBounds.x
		isGrounded = true
		print("SNAPPING TO " + str(objectPos.y))
	
	if  currentFloor != null && !isGrounded && isJumping:
		objectPos.y = currentFloor.get_bottom_pos() - yBounds.y
		yVelocity = 0
		print("OWIE MY HEAD")
	

func _draw() -> void:
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
