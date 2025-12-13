extends Node2D

class SortableObject:
	var object_type: String
	var position: Vector3
	var bounds: Dictionary
	var color: Color = Color.WHITE

	func _init(object_type, position, bounds, color=Color.WHITE):
		self.object_type = object_type
		self.position = position
		self.bounds = bounds
		self.color = color

var sorted_objects: Array = []

func _ready():
	var objects = [
		SortableObject.new("floor", Vector3(0, 0, 0), {"x_min": -50, "x_max": 50, "z_min": -50, "z_max": 50}, Color.GRAY),
		SortableObject.new("normal_wall", Vector3(-25, -50, 20), {"x_min": -50, "x_max": 0, "y_min": -50, "y_max": 50}, Color.RED),
		SortableObject.new("z_wall", Vector3(25, -50, 0), {"z_min": -50, "z_max": 50, "y_min": -50, "y_max": 50}, Color.BLUE),
		SortableObject.new("entity", Vector3(10, -20, 10), {"x_min": -5, "x_max": 5, "y_min": -5, "y_max": 5, "z_min": -5, "z_max": 5}, Color.GREEN),
	]

	sorted_objects = sort_scene(objects)
	queue_redraw()  # Triggers _draw()

func _draw():
	draw_scene(sorted_objects)

func sort_scene(objects: Array) -> Array:
	objects.sort_custom(func(a, b): return compare_objects(a, b))
	return objects

func compare_objects(a: SortableObject, b: SortableObject) -> int:
	# Step 1: Ensure floors are always below everything else on the same y level
	if a.object_type == "floor" and b.object_type != "floor":
		return -1  # Floor should be behind others
	if b.object_type == "floor" and a.object_type != "floor":
		return 1  # Floor should be behind others
	
	# Step 2: Sort by z first (further from camera are drawn later, i.e. higher z is first)
	if a.position.z != b.position.z:
		return int(b.position.z - a.position.z)  # Objects with higher z come first (closer to the camera)
	
	# Step 3: Then by y position (higher y is rendered later)
	if a.position.y != b.position.y:
		return int(b.position.y - a.position.y)  # Objects with higher y are drawn later
	
	# Step 4: Finally, by x position (left to right)
	if a.position.x != b.position.x:
		return int(a.position.x - b.position.x)  # Objects with smaller x come first

	return 0  # If all values are the same, they are considered equal in sorting



func is_within_floor_bounds(floor: SortableObject, obj: SortableObject) -> bool:
	var x = obj.position.x
	var z = obj.position.z
	return (
		floor.bounds["x_min"] <= x and x <= floor.bounds["x_max"] and
		floor.bounds["z_min"] <= z and z <= floor.bounds["z_max"] and
		obj.position.y == floor.position.y
	)

func compare_z_wall_cases(a: SortableObject, b: SortableObject) -> int:
	var wall = a if a.object_type == "z_wall" else b
	var other = b if a.object_type == "z_wall" else a

	if other.position.y < wall.bounds["y_min"] or other.position.y > wall.bounds["y_max"]:
		return 0
	if other.position.x < wall.position.x:
		return -1 if wall == a else 1
	elif other.position.x > wall.position.x:
		return 1 if wall == a else -1
	return 0

func cabinet_project(pos: Vector3) -> Vector2:
	# Cabinet projection with 45 degree angle on Z
	return Vector2(
		pos.x + pos.z * 0.5,
		pos.y - pos.z * 0.5
	)

func draw_scene(objects: Array):
	for obj in objects:
		match obj.object_type:
			"floor":
				draw_floor(obj)
			"normal_wall":
				draw_normal_wall(obj)
			"z_wall":
				draw_z_wall(obj)
			"entity":
				draw_entity(obj)

func draw_floor(floor: SortableObject):
	var x0 = floor.bounds["x_min"]
	var x1 = floor.bounds["x_max"]
	var z0 = floor.bounds["z_min"]
	var z1 = floor.bounds["z_max"]
	var y = floor.position.y
	var points = [
		cabinet_project(Vector3(x0, y, z0)),
		cabinet_project(Vector3(x1, y, z0)),
		cabinet_project(Vector3(x1, y, z1)),
		cabinet_project(Vector3(x0, y, z1))
	]
	draw_colored_polygon(points, floor.color)
	points.append(points[0])
	draw_polyline(points, Color.BLACK, 1.0, true)

func draw_normal_wall(wall: SortableObject):
	var x0 = wall.bounds["x_min"]
	var x1 = wall.bounds["x_max"]
	var y0 = wall.bounds["y_min"]
	var y1 = wall.bounds["y_max"]
	var z = wall.position.z
	var points = [
		cabinet_project(Vector3(x0, y0, z)),
		cabinet_project(Vector3(x1, y0, z)),
		cabinet_project(Vector3(x1, y1, z)),
		cabinet_project(Vector3(x0, y1, z))
	]
	draw_colored_polygon(points, wall.color)
	points.append(points[0])
	draw_polyline(points, Color.BLACK, 1.0, true)

func draw_z_wall(wall: SortableObject):
	var z0 = wall.bounds["z_min"]
	var z1 = wall.bounds["z_max"]
	var y0 = wall.bounds["y_min"]
	var y1 = wall.bounds["y_max"]
	var x = wall.position.x
	var points = [
		cabinet_project(Vector3(x, y0, z0)),
		cabinet_project(Vector3(x, y0, z1)),
		cabinet_project(Vector3(x, y1, z1)),
		cabinet_project(Vector3(x, y1, z0))
	]
	draw_colored_polygon(points, wall.color)
	points.append(points[0])
	draw_polyline(points, Color.BLACK, 1.0, true)

func draw_entity(entity: SortableObject):
	var pos = entity.position
	var x0 = pos.x + entity.bounds["x_min"]
	var x1 = pos.x + entity.bounds["x_max"]
	var y0 = pos.y + entity.bounds["y_min"]
	var y1 = pos.y + entity.bounds["y_max"]
	var z0 = pos.z + entity.bounds["z_min"]
	var z1 = pos.z + entity.bounds["z_max"]
	var points = [
		cabinet_project(Vector3(x0, y0, z0)),
		cabinet_project(Vector3(x1, y0, z0)),
		cabinet_project(Vector3(x1, y1, z1)),
		cabinet_project(Vector3(x0, y1, z1))
	]
	draw_colored_polygon(points, entity.color)
	points.append(points[0])
	draw_polyline(points, Color.BLACK, 1.0, true)
