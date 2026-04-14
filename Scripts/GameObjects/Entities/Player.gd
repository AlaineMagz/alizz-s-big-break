@tool
class_name Player extends Entity

func _ready():
	pass

func _physics_process(delta):
	
	if(!Engine.is_editor_hint()):
		handle_inputs()
	
	handle_floor()
	
	handle_wall()
	
	if(!Engine.is_editor_hint()):
		handle_vertical(delta)
	
	calculate_2D_position()
	
	if drawDebug:
		queue_redraw()
	

func handle_inputs():
	
	if Input.get_axis("left","right") != 0:
		objectPos.x += speed * Input.get_axis("left","right")
	
	if Input.get_axis("up","down") != 0:
		objectPos.z += speed * -Input.get_axis("up","down")
	
	if Input.is_action_just_pressed("jump"):
		isJumping = true
		yVelocity = jumpPower
	
