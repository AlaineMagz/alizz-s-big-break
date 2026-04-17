@tool
class_name Geometry extends GameObject

func _draw() -> void:
	
	if drawDebug:
		draw_colored_polygon(getTopFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getTopFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getFrontFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getFrontFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
		
		draw_colored_polygon(getSideFacePoints(xBounds,yBounds,zBounds), debugColor)
		draw_polyline(getSideFaceBorderPoints(xBounds,yBounds,zBounds), debugOutlineColor, debugOutlineWeight)
