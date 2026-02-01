extends Node2D
var objects = dir_contents("./Scenes/Tiles")
var tiling: Vector2 = Vector2(7,4)
const interact_radius = 120
var ignore_input = false

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


func spawn_object(index: int, real: bool) -> void:
	var object_pair = objects.pick_random()
	var real_object = object_pair[0].instantiate()
	var shadow_object = object_pair[1].instantiate()
	
	var uuid_name = UUID.v7()
	real_object.name = uuid_name
	shadow_object.name = uuid_name
	
	var scale = real_object.transform.get_scale()
	var skew = deg_to_rad(randf_range(-5,5))
	var size = scale * real_object.get_child(0).texture.get_size()
	var transf = Transform2D(0, scale, 0, gen_random_pos_in_spawn_area(size, index))
	real_object.transform = transf
	shadow_object.transform = transf
	if real:
		$RealWorld.add_child(real_object)
	$ShadowWorld.add_child(shadow_object)

func enter_firstperson() -> void:
	var simultaneous_scene = preload("res://Scenes/firstperson/firstperson.tscn").instantiate()
	get_parent().add_child(simultaneous_scene)
	find_child("RenderLayer").hide()
	ignore_input = true
	hide()
	
func return_from_firstperson() -> void:
	ignore_input = false
	
	var empty = len($ShadowWorld.get_children()) == len($RealWorld.get_children())
	if empty:
		var container = get_node("/root/MainMenu")
		container.reload_level()
		
	show()
	find_child("RenderLayer").show()

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
		spawn_object(index, i % 2 == 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	if LeapMotionClient.hand_position != null:
		mouse_pos = LeapMotionClient.hand_position * Vector2(1920, 1080)
	$RenderLayer/RealWorld.material.set("shader_parameter/mouse_position", mouse_pos)
	$HandCollider.position = mouse_pos
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and !ignore_input:
		var mouse_pos = get_global_mouse_position()
		if LeapMotionClient.hand_position != null:
			mouse_pos = LeapMotionClient.hand_position * Vector2(1920, 1080)
		
		var objects: Array[Node] = $ShadowWorld.get_children()
		for obj in objects:
			if obj.name == "Background":
				continue
			var size = obj.transform.get_scale() * obj.get_child(0).texture.get_size()
			var position = obj.position + size / 2
			var distance = mouse_pos.distance_to(position)
			if distance < interact_radius:
				var objectss: Array[Node] = $RealWorld.get_children()
				for objs in objectss:
					if objs.name == obj.name:
						return
				$ShadowWorld.remove_child(obj)
				enter_firstperson()
