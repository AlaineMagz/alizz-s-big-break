@tool
extends Node2D

@export var geometry_list: Array[Node]

func _process(_delta: float) -> void:
	
	geometry_list = get_child(0).get_children() + get_child(1).get_children()
	

func get_close_objects() -> Array[GameObject]:
	
	var objects : Array[GameObject]
	
	#TODO
	
	return objects
	
