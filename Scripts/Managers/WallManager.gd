@tool
extends Node2D
class_name wallManager

@export var wallArr: Array[Node2D]

func _process(_delta : float) -> void:
	
	maintain_array()
	

func maintain_array() -> void:
	
	if get_child_count() < wallArr.size():
		
		var removed : bool = false
		
		for index in wallArr.size():
			
			if index == get_child_count() && !removed:
				wallArr.remove_at(index - 1)
				removed = true
				return
			
			if wallArr[index] != get_child(index) && !removed:
				removed = true
				wallArr.remove_at(index)
			
	
	for wl in get_child_count():
		
		var found : bool = false
		
		for w in wallArr:
			
			if get_child(wl) == w:
				found = true
		
		if !found:
			wallArr.append(get_child(wl))
	
