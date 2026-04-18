@tool
extends Node2D

@export var geometry_list: Array[Node]
@export var ordered_geometry_list : Array[Geometry]

func _process(_delta: float) -> void:
	
	geometry_list = get_child(0).get_children() + get_child(1).get_children()
	
	if ordered_geometry_list.is_empty():
		sort_geometry()
	

func sort_geometry() -> void:
	
	ordered_geometry_list.assign(geometry_list)
	ordered_geometry_list.sort_custom(compareObjects)
	

func compareObjects(object1 : GameObject, object2 : GameObject) -> bool:
	
	if object1.get_back_pos() <= object2.get_front_pos():
		return true
	if object1.get_front_pos() >= object2.get_back_pos():
		return false
	
	if object1.get_bottom_pos() >= object2.get_top_pos():
		return true
	if object1.get_top_pos() <= object2.get_bottom_pos():
		return false
	
	if object1.get_left_pos() >= object2.get_right_pos():
		return true
	if object1.get_right_pos() <= object2.get_left_pos():
		return false
	
	if object1.objectPos.y > object2.objectPos.y:
		return true
	
	return object1.get_instance_id() < object2.get_instance_id()
	

func get_close_objects() -> Array[GameObject]:
	
	var objects : Array[GameObject]
	
	#TODO
	
	return objects
	
