@tool
extends Node2D

@export var player: Node2D
@export var level: Node2D
@export var entities: Node2D

var layerOrder: Array[GameObject]

func _process(_delta : float) -> void:
	
	layerOrder = getAllObjects()
	layerOrder.sort_custom(compareObjects)
	applyIndexes()
	

func getAllObjects() -> Array[GameObject]:
	
	var gameObjects : Array[GameObject]
	gameObjects.append(player)
	gameObjects.append_array(level.geometry_list)
	# ADD THE ENTITY ARRAY HERE
	
	return gameObjects
	

func applyIndexes() -> void:
	
	var index : int = 2048
	
	for layer in layerOrder:
		layer.z_index = index
		index -= 1
	

func compareObjects(object1 : GameObject, object2 : GameObject) -> bool:
	
	if object1.get_back_pos() <= object2.get_front_pos():
		return true
	else: if object1.get_front_pos() >= object2.get_back_pos():
		return false
	
	if object1.get_bottom_pos() >= object2.get_top_pos():
		return true
	else: if object1.get_top_pos() <= object2.get_bottom_pos():
		return false
	
	if object1.get_left_pos() >= object2.get_right_pos():
		return true
	else: if object1.get_right_pos() <= object2.get_left_pos():
		return false
	
	return false
	
