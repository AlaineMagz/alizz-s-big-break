@tool
class_name Floor extends GameObject

@export var yLevel : float = 0

func _process(_delta):
	yLevel = yBounds.y

func _draw():
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
	
