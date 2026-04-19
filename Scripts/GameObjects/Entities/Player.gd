@tool
class_name Player extends Entity

func _physics_process(delta : float) -> void:
	
	if(!Engine.is_editor_hint()):
		handle_inputs()
		
		handle_physics(delta)
		
	
	if drawDebug:
		queue_redraw()
	

func handle_inputs() -> void :
	
	xVelocity = speed * Input.get_axis("left","right")
	
	zVelocity = speed * -Input.get_axis("up","down")
	
	if Input.is_action_just_pressed("jump") && isGrounded:
		objectPos.y += 0.1
		isGrounded = false
		isJumping = true
		yVelocity = jumpPower
	
