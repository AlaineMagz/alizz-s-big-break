@tool
class_name NPC extends Entity


func _ready() -> void:
	
	levelManager = get_parent().get_parent()
	

func _physics_process(delta : float) -> void:
	
	if(!Engine.is_editor_hint()):
		handle_physics(delta)
	
	if drawDebug:
		queue_redraw()
	
