@tool
class_name Entity extends GameObject

@export_group("Entity")
@export var cb2d : CharacterBody2D

@export_group("Entity Nodes")
@export var levelManager: Node2D
@export var currentFloor : Geometry

@export_group("Entity Visual")
var spriteNode : Sprite2D

@export var sprite : CompressedTexture2D:
	set(value):
		sprite = value
		if is_node_ready():
			handle_sprite()

@export var spriteOffset : Vector3 = Vector3.ZERO:
	set(value):
		spriteOffset = value
		if is_node_ready():
			handle_sprite()

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
@export var xVelocity : float = 0
@export var yVelocity : float = 0
@export var zVelocity : float = 0

func handle_physics(delta : float) -> void:
	
	if !isGrounded:
		yVelocity -= fallSpeed * delta
	else:
		yVelocity = -0.1
	yVelocity = clamp(yVelocity, -terminalVelocity, terminalVelocity * 5)
	
	if yVelocity < 0:
		isFalling = true
		isJumping = false
	
	if yVelocity > 0:
		isJumping = true
		isFalling = false
	
	objectPos.y += yVelocity
	handle_vertical_collision()
	
	objectPos.x += xVelocity
	handle_horizontal_x_collision()
	
	objectPos.z += zVelocity
	handle_horizontal_z_collision()
	
	calculate_2D_position()
	

func handle_vertical_collision() -> void:
	
	var overlapped : bool = false
	
	for geometry : Geometry in levelManager.geometry_list:
		
		if is_overlapping_vertically(self, geometry):
			
			overlapped = true
			
			if isFalling:
				objectPos.y = geometry.get_top_pos() - yBounds.x
				yVelocity = 0
				isGrounded = true
				isFalling = false
				#print("SNAPPING TO " + str(objectPos.y))
			elif isJumping:
				objectPos.y = geometry.get_bottom_pos() - yBounds.y
				yVelocity = 0
				isJumping = false
				#print("OWIE MY HEAD")
			
		
	
	if !overlapped:
		isGrounded = false
	

func handle_horizontal_x_collision() -> void:
	
	for geometry : Geometry in levelManager.geometry_list:
		
		if is_overlapping_horizontally(self, geometry):
			
			if xVelocity > 0:
				objectPos.x = geometry.get_left_pos() - xBounds.y
			elif xVelocity < 0:
				objectPos.x = geometry.get_right_pos() - xBounds.x
			
			xVelocity = 0
			
		
	

func handle_horizontal_z_collision() -> void:
	
	for geometry : Geometry in levelManager.geometry_list:
		
		if is_overlapping_horizontally(self, geometry):
			
			if zVelocity > 0:
				objectPos.z = geometry.get_front_pos() - zBounds.y
			elif zVelocity < 0:
				objectPos.z = geometry.get_back_pos() - zBounds.x
			
			zVelocity = 0
			
		
	

func handle_sprite() -> void:
	
	if sprite == null:
		return
	
	var found : bool = false
	
	for child in self.get_children(true):
		if child.name == "EntitySprite":
			spriteNode = child
			found = true
	
	if !found:
		spriteNode = Sprite2D.new()
		spriteNode.name = "EntitySprite"
		add_child(spriteNode)
		spriteNode.owner = get_tree().edited_scene_root
	
	spriteNode.texture = sprite
	spriteNode.position = get_2D_position(spriteOffset)
	

func _draw() -> void:
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
