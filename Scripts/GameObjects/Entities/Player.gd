@tool
class_name Player extends Entity

func _physics_process(delta : float) -> void:
	
	if(!Engine.is_editor_hint()):
		handle_inputs()
		
		handle_physics(delta)
		
	
	if drawDebug:
		queue_redraw()
	

func handle_inputs() -> void :
	
	if Input.get_axis("left","right") != 0:
		objectPos.x += speed * Input.get_axis("left","right")
	
	if Input.get_axis("up","down") != 0:
		objectPos.z += speed * -Input.get_axis("up","down")
	
	if Input.is_action_just_pressed("jump"):
		objectPos.y += 0.1
		isGrounded = false
		isJumping = true
		yVelocity = jumpPower
	
