extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_play_pressed() -> void:
	var gameContainer = find_child("gameContainer")
	var simultaneous_scene = preload("res://Scenes/game.tscn").instantiate()
	gameContainer.add_child(simultaneous_scene)
	gameContainer.show()
	find_child("menuContainer").hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func show_game_over() -> void:
	find_child("gameContainer").get_child(0).free()
	var simultaneous_scene = preload("res://Scenes/GameOver.tscn").instantiate()
	find_child("gameContainer").add_child(simultaneous_scene)

func return_from_game_session() -> void:
	var gameContainer = find_child("gameContainer")
	gameContainer.get_child(0).queue_free()
	gameContainer.hide()
	find_child("menuContainer").show()
