@tool
class_name Wall extends GameObject

@export_category("Bounds")

@export var zAxis: bool = false:
	set(value):
		zAxis = value
		queue_redraw()

func _draw():
	
	if drawDebug:
		if zAxis:
			draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
			draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		else:
			draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
			draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
	
	
	print("HI")
	
