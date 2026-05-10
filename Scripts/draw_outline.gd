extends Control

@export var debug_panel : Control

var hovered_object : GameObject
@export var hover_outline_color : Color = Color.YELLOW
var selected_object_1 : GameObject
var selected_object_2 : GameObject
@export var selected_outline_color : Color = Color.ORANGE_RED

func _process(_delta: float) -> void:
	
	hovered_object = debug_panel.hovered_object
	selected_object_1 = debug_panel.selected_object_1
	selected_object_2 = debug_panel.selected_object_2
	
	if hovered_object != null || selected_object_1 != null || selected_object_2 != null:
		queue_redraw()
	

func _draw() -> void:
	
	self.z_index = 4096
	
	if hovered_object != null:
		self.position = hovered_object.position
		draw_polyline(hovered_object.getTopFaceBorderPoints(hovered_object.xBounds,hovered_object.yBounds,hovered_object.zBounds), hover_outline_color, hovered_object.debugOutlineWeight)
		draw_polyline(hovered_object.getFrontFaceBorderPoints(hovered_object.xBounds,hovered_object.yBounds,hovered_object.zBounds), hover_outline_color, hovered_object.debugOutlineWeight)
		draw_polyline(hovered_object.getSideFaceBorderPoints(hovered_object.xBounds,hovered_object.yBounds,hovered_object.zBounds), hover_outline_color, hovered_object.debugOutlineWeight)
	
