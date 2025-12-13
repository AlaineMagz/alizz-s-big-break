@tool
extends Node2D

@export var player: Node2D
@export var level: Node2D
@export var entities: Node2D

var xDict : Dictionary = {}
var yDict : Dictionary = {}
var zDict : Dictionary = {}

var xArr : Array[Node2D]
var yArr : Array[Node2D]
var zArr : Array[Node2D]

func _process(_delta):
	
	clearArrs()
	
	#getArrays()

func clearArrs():
	
	xDict.clear()
	yDict.clear()
	zDict.clear()
	

func getAllObjects():
	
	var gameObjects : Array[GameObject]
	gameObjects.append(player)
	gameObjects.append_array(level.floorManager.floorArr)
	gameObjects.append_array(level.wallManager.wallArr)
	# ADD THE ENTITY ARRAY HERE
	
	return gameObjects
	

func getArrays():
	
	var gameObjects : Array[GameObject] = getAllObjects()
	
	var rank = 1
	while !gameObjects.is_empty():
		var lowestY : Array[GameObject]
		lowestY.append(gameObjects.get(0))
		for obj in gameObjects:
			if((minf(obj.yBounds.x, obj.yBounds.y) + obj.objectPos.y) < (minf(lowestY[0].yBounds.x, lowestY[0].yBounds.y) + lowestY[0].objectPos.y)):
				lowestY.clear()
				lowestY.append(obj)
			else: if((minf(obj.yBounds.x, obj.yBounds.y) + obj.objectPos.y) == (minf(lowestY[0].yBounds.x, lowestY[0].yBounds.y) + lowestY[0].objectPos.y)):
				lowestY.append(obj)
		for obj in lowestY:
			yDict.get_or_add(obj, rank)
			gameObjects.erase(obj)
		rank += 1
	
	print("\nY Dictionary:")
	print(yDict)
	
	gameObjects = getAllObjects()
	
	rank = 1
	while !gameObjects.is_empty():
		var lowestX : Array[GameObject]
		lowestX.append(gameObjects.get(0))
		for obj in gameObjects:
			if((minf(obj.xBounds.x, obj.xBounds.y) + obj.objectPos.x) < (minf(lowestX[0].xBounds.x, lowestX[0].xBounds.y) + lowestX[0].objectPos.x)):
				lowestX.clear()
				lowestX.append(obj)
			else: if((minf(obj.xBounds.x, obj.xBounds.y) + obj.objectPos.x) == (minf(lowestX[0].xBounds.x, lowestX[0].xBounds.y) + lowestX[0].objectPos.x)):
				lowestX.append(obj)
		for obj in lowestX:
			xDict.get_or_add(obj, rank)
			gameObjects.erase(obj)
		rank += 1
	
	print("\nX Dictionary:")
	print(xDict)
	
	gameObjects = getAllObjects()
	
	rank = 1
	while !gameObjects.is_empty():
		var highestZ : Array[GameObject]
		highestZ.append(gameObjects.get(0))
		for obj in gameObjects:
			if((maxf(obj.zBounds.x, obj.zBounds.y) + obj.objectPos.z) > (maxf(highestZ[0].zBounds.x, highestZ[0].zBounds.y) + highestZ[0].objectPos.z)):
				highestZ.clear()
				highestZ.append(obj)
			else: if((maxf(obj.zBounds.x, obj.zBounds.y) + obj.objectPos.z) == (maxf(highestZ[0].zBounds.x, highestZ[0].zBounds.y) + highestZ[0].objectPos.z)):
				highestZ.append(obj)
		for obj in highestZ:
			zDict.get_or_add(obj, rank)
			gameObjects.erase(obj)
		rank += 1
	
	print("\nZ Dictionary:")
	print(zDict)
	
