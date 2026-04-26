@tool
extends Node2D

@export var player: Player
@export var level: LevelManager

var layerOrder: Array[GameObject]

func _process(_delta : float) -> void:
	
	layerOrder.assign(level.ordered_geometry_list)
	
	for entity in level.entity_list:
		var index : int = layerOrder.bsearch_custom(entity, compareObjects)
		layerOrder.insert(index, entity)
	
	var player_index : int = layerOrder.bsearch_custom(player, compareObjects)
	
	layerOrder.insert(player_index, player)
	
	applyIndexes()
	
	#if !Engine.is_editor_hint():
		#var indices : String = ""
		#for layer in layerOrder:
			#indices += str(layer.name) + " "
		#print(indices)

func applyIndexes() -> void:
	
	var index : int = 2048
	
	for layer in layerOrder:
		layer.z_index = index
		index -= 1
	

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
	
