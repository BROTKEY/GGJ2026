extends Node2D
var objects = dir_contents("./Scenes/Tiles")
var tiling: Vector2 = Vector2(7,4)

func gen_random_pos_in_spawn_area(obj_size: Vector2, index: int):
	var spawnArea = $Spawn/Objects.shape.size - obj_size
	var origin = $Spawn/Objects.transform.origin - $Spawn/Objects.shape.size / 2 
	var x = floor(index / int(tiling.y))
	var y = index % int(tiling.y)
	var pix_x = origin.x + x* spawnArea.x/(tiling.x-1)
	var pix_y = origin.y + y* spawnArea.y/(tiling.y-1)

	return Vector2(pix_x, pix_y)

func dir_contents(path) -> Array:
	var scene_loads = []
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with("_shadow.tscn"):
				file_name = dir.get_next()
				continue
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					var alt_path = full_path.get_basename() + "_shadow.tscn"
					print("Found scene pair: ", full_path, "; ", alt_path)
					scene_loads.append([load(full_path), load(alt_path)])
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return scene_loads


func spawn_object(index: int) -> void:
	var object_pair = objects.pick_random()
	var real_object = object_pair[0].instantiate()
	var shadow_object = object_pair[1].instantiate()
	var scale = real_object.transform.get_scale()
	var skew = deg_to_rad(randf_range(-5,5))
	var size = scale * real_object.get_child(0).texture.get_size()
	var transf = Transform2D(0, scale, 0, gen_random_pos_in_spawn_area(size, index))
	real_object.transform = transf
	shadow_object.transform = transf
	$RealWorld.add_child(real_object)
	$ShadowWorld.add_child(shadow_object)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var positions = Array(range(0, tiling.y))
	for i in range(tiling.x - 2):
		positions.append(int(tiling.y * (i+1)))
		positions.append(int(tiling.y* (i+1) + tiling.y-1))
	positions.append_array(range(tiling.x*tiling.y- tiling.y,  tiling.x*tiling.y))
	for i in 8:
		positions.shuffle()
		var index = positions.pop_front()
		spawn_object(index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	$RenderLayer/RealWorld.material.set("shader_parameter/mouse_position", mouse_pos)
