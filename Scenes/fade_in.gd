extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = find_child("Timer").wait_time
	var cur_time = find_child("Timer").time_left
	var rect: TextureRect = find_child("TextureRect")
	if cur_time == 0:
		var container = get_node("/root/MainMenu")
		container.reload_level()
	
	rect.modulate = Color(cur_time/time,cur_time/time,cur_time/time,1)
	pass
