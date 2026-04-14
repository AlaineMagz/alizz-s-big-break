@tool
extends Node2D
class_name floorManager

@export var floorArr: Array[Node2D]

func _process(_delta):
	
	
	maintain_array()
	

func maintain_array():
	
	if get_child_count() < floorArr.size():
		
		var removed = false
		
		for index in floorArr.size():
			
			if index == get_child_count() && !removed:
				floorArr.remove_at(index - 1)
				removed = true
				return
			
			if floorArr[index] != get_child(index) && !removed:
				removed = true
				floorArr.remove_at(index)
			
	
	for fl in get_child_count():
		
		var found = false
		
		for f in floorArr:
			
			if get_child(fl) == f:
				found = true
		
		if !found:
			floorArr.append(get_child(fl))
	
