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
	
	for fl in levelManager.floorManager.floorArr:
		
		var inBounds = false
		var sameYLevel = false
		
		if fl.yLevel == objectPos.y + min(yBounds.x, yBounds.y):
			sameYLevel = true
		else: if objectPos.y + min(yBounds.x, yBounds.y) > fl.yLevel && ((objectPos.y + min(yBounds.x, yBounds.y)) - fl.yLevel) < fallSpeed:
			objectPos.y = fl.yLevel
			sameYLevel = true
		
		if (objectPos.x + max(xBounds.x, xBounds.y) > fl.xBounds.x && objectPos.x + min(xBounds.x, xBounds.y) < fl.xBounds.y) && (objectPos.z + max(zBounds.x, zBounds.y) > fl.zBounds.x && objectPos.z + min(zBounds.x, zBounds.y) < fl.zBounds.y):
			inBounds = true
		
		if inBounds && sameYLevel:
			currentFloor = fl
			floorFound = true
		
	
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
	

func calculate_2D_position():
	
	position = Vector2(objectPos.x + (objectPos.z) / 2, -(objectPos.y + (objectPos.z / 2)))
