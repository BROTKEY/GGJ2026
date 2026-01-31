extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_play_pressed() -> void:
	var simultaneous_scene = preload("res://Scenes/game.tscn").instantiate()
	find_child("gameContainer").add_child(simultaneous_scene)
	
func _on_quit_pressed() -> void:
	get_tree().quit()
