extends Node2D
var objects: Array[PackedScene] = dir_contents("./Scenes/Tiles")
var tiling: Vector2 = Vector2(3,5)

func gen_random_pos_in_spawn_area(obj_size: Vector2):
	var positions = Array(range(0, tiling.y))
	positions.append_array()
	
	var spawnArea = $Spawn/Objects.shape.size
	var origin = $Spawn/Objects.transform.origin
	var side = randi_range(0,3)
	if side == 0:
		return Vector2(origin.x - spawnArea.x/2, randf_range(origin.y - spawnArea.y/2, origin.y + spawnArea.y/2 - obj_size.y))
	if side ==1:
		return Vector2(randf_range(origin.x - spawnArea.x/2, origin.x + spawnArea.x/2 - obj_size.x), origin.y- spawnArea.y/2)
	if side == 2:
		return Vector2(origin.x + spawnArea.x/2 - obj_size.x, randf_range(origin.y - spawnArea.y/2, origin.y + spawnArea.y/2 - obj_size.y))
	if side == 3:
		return Vector2(randf_range(origin.x - spawnArea.x/2, origin.x + spawnArea.x/2 - obj_size.x), origin.y + spawnArea.y/2 - obj_size.y)


func dir_contents(path) -> Array[PackedScene]:
	var scene_loads: Array[PackedScene] = []	

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					scene_loads.append(load(full_path))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return scene_loads
	
func spawn_object() -> void:
	var object = objects.pick_random().instantiate()
	var scale = object.transform.get_scale()
	var skew = deg_to_rad(randf_range(-5,5))
	var size = scale * object.get_child(0).texture.get_size()
	object.transform = Transform2D(0, scale, 0, gen_random_pos_in_spawn_area(size))
	$Spawn.add_child(object)
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 8:
		spawn_object()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
