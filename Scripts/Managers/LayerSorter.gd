@tool
extends Node2D

@export var player: Node2D
@export var level: Node2D
@export var entities: Node2D

var layerOrder: Array[GameObject]

func _process(_delta):
	
	layerOrder.clear()
	sortLayers()
	applyIndexes()
	

func getAllObjects():
	
	var gameObjects : Array[GameObject]
	gameObjects.append(player)
	gameObjects.append_array(level.floorM.floorArr)
	gameObjects.append_array(level.wallM.wallArr)
	# ADD THE ENTITY ARRAY HERE
	
	return gameObjects
	

func sortLayers():
	
	var gameObjects : Array[GameObject] = getAllObjects()
	
	layerOrder.append(gameObjects[0])
	gameObjects.remove_at(0)
	
	for object in gameObjects:
		
		var done = false
		
		for layer in layerOrder.size():
			
			if compareObjects(object, layerOrder[layer]) && !done:
				layerOrder.insert(layer, object)
				done = true
			else: if layer == layerOrder.size() - 1 && !done:
				layerOrder.append(object)
			
		
	

func applyIndexes():
	
	var index = 2048
	
	for layer in layerOrder:
		layer.z_index = index
		index -= 1
	

func compareObjects(object1 : GameObject, object2 : GameObject):
	
	if object1.get_top_pos() > object2.get_top_pos():
		return true
	else: if object1.get_top_pos() < object2.get_top_pos():
		return false
	
	if object1.get_front_pos() < object2.get_front_pos():
		return true
	else: if object1.get_front_pos() > object2.get_front_pos():
		return false
	
	if object1.get_right_pos() > object2.get_right_pos():
		return true
	else: if object1.get_right_pos() < object2.get_right_pos():
		return false
	
	return false
	
