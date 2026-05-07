extends Control

@onready var debug_panel : Panel = self.get_child(2)
@export var level : LevelManager
@export var player : Player

var left_object : GameObject
@export var left_name : Label
@export var left_top : Label
@export var left_bottom : Label
@export var left_front : Label
@export var left_back : Label
@export var left_left : Label
@export var left_right : Label

var right_object : GameObject
@export var right_name : Label
@export var right_top : Label
@export var right_bottom : Label
@export var right_front : Label
@export var right_back : Label
@export var right_left : Label
@export var right_right : Label

var selected_object_1 : GameObject
var selected_object_2 : GameObject

var list_of_hovered_objects : Array[GameObject]

var mouse_in_window : bool = false
var last_mouse_position : Vector2

func _process(_delta: float) -> void:
	
	if mouse_in_window && (last_mouse_position != get_global_mouse_position()):
		
		list_of_hovered_objects.clear()
		var level_objects : Array[Node] = level.geometry_list + level.entity_list
		level_objects.append(player)
		
		for object in level_objects:
			if is_object_under_mouse(object):
				list_of_hovered_objects.append(object)
		
	
	last_mouse_position = get_global_mouse_position()
	

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("mouse1"):
		
		if left_object == null && !list_of_hovered_objects.is_empty():
			left_object = list_of_hovered_objects[0]
			update_left_labels()
		elif list_of_hovered_objects.has(left_object):
			var i : int = (list_of_hovered_objects.find(left_object) + 1) % list_of_hovered_objects.size()
			left_object = list_of_hovered_objects[i]
			update_left_labels()
		elif !list_of_hovered_objects.is_empty():
			left_object = list_of_hovered_objects[0]
			update_left_labels()
		
	
	if event.is_action_pressed("mouse2"):
		
		if right_object == null && !list_of_hovered_objects.is_empty():
			right_object = list_of_hovered_objects[0]
			update_right_labels()
		elif list_of_hovered_objects.has(right_object):
			var i : int = (list_of_hovered_objects.find(right_object) + 1) % list_of_hovered_objects.size()
			right_object = list_of_hovered_objects[i]
			update_right_labels()
		elif !list_of_hovered_objects.is_empty():
			right_object = list_of_hovered_objects[0]
			update_right_labels()
		
	
	if event.is_action_pressed("interact"):
		print(list_of_hovered_objects)
	

func update_left_labels() -> void:
	left_name.text = "Name: " + left_object.name
	left_top.text = "Top Pos: " + str(left_object.get_top_pos())
	left_bottom.text = "Bottom Pos: " + str(left_object.get_bottom_pos())
	left_front.text = "Front Pos: " + str(left_object.get_front_pos())
	left_back.text = "Back Pos: " + str(left_object.get_back_pos())
	left_left.text = "Left Pos: " + str(left_object.get_left_pos())
	left_right.text = "Right Pos: " + str(left_object.get_right_pos())

func update_right_labels() -> void:
	right_name.text = "Name: " + right_object.name
	right_top.text = "Top Pos: " + str(right_object.get_top_pos())
	right_bottom.text = "Bottom Pos: " + str(right_object.get_bottom_pos())
	right_front.text = "Front Pos: " + str(right_object.get_front_pos())
	right_back.text = "Back Pos: " + str(right_object.get_back_pos())
	right_left.text = "Left Pos: " + str(right_object.get_left_pos())
	right_right.text = "Right Pos: " + str(right_object.get_right_pos())

func is_object_under_mouse(object : GameObject) -> bool:
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	var object_2d_pos : Vector2 = object.get_2D_position(object.objectPos)
	var object_front_verts : PackedVector2Array = object.getFrontFacePoints(object.xBounds, object.yBounds, object.zBounds)
	var object_side_verts : PackedVector2Array = object.getSideFacePoints(object.xBounds, object.yBounds, object.zBounds)
	var object_top_verts : PackedVector2Array = object.getTopFacePoints(object.xBounds, object.yBounds, object.zBounds)
	
	if is_point_in_polygon(mouse_pos, translate_verts(object_2d_pos, object_front_verts)):
		return true
	
	if is_point_in_polygon(mouse_pos, translate_verts(object_2d_pos, object_side_verts)):
		return true
	
	if is_point_in_polygon(mouse_pos, translate_verts(object_2d_pos, object_top_verts)):
		return true
	
	return false
	

func translate_verts(pos : Vector2, verts : PackedVector2Array) -> PackedVector2Array:
	
	for i in range(verts.size()):
		verts[i] += pos
	
	return verts
	

func is_point_in_polygon(point : Vector2, verts : PackedVector2Array) -> bool:
	
	var inside : bool = false
	var n : int = verts.size()
	var j : int = 0
	var x_intersect : float = INF - 1
	
	for i in range(n + 1):
		if point.y > min(verts[j].y, verts[i % n].y):
			if point.y <= max(verts[j].y, verts[i % n].y):
				if point.x <= max(verts[j].x, verts[i %n].x):
					if verts[j].y != verts[i % n].y:
						x_intersect = (point.y - verts[j].y) * (verts[i % n].x - verts[j].x) / (verts[i % n].y - verts[j].y) + verts[j].x
					if verts[j].x == verts[i % n].x or point.x <= x_intersect:
						inside = !inside
		j = i
	
	return inside
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		mouse_in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		mouse_in_window = false

func _on_button_pressed() -> void:
	debug_panel.visible = !debug_panel.visible
