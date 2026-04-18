extends Label

@export var player : Player

func _process(_delta: float) -> void:
	
	text = "Y Velocity: " + str(player.yVelocity)
	
