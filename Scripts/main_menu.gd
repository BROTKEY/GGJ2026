extends Control


@onready var debug_menu = $BopItDebugMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BopItDebugMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_level() -> void:
	var gameContainer = find_child("gameContainer")
	var simultaneous_scene = preload("res://Scenes/game.tscn").instantiate()
	gameContainer.add_child(simultaneous_scene)
	gameContainer.show()
	find_child("menuContainer").hide()
	
func reload_level() -> void:
	for c in find_child("gameContainer").get_children():
		c.hide()
		c.queue_free()
	load_level()
	
func _on_play_pressed() -> void:
	load_level()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key"):
		debug_menu.visible = !debug_menu.visible

func show_game_over() -> void:
	for c in find_child("gameContainer").get_children():
		c.hide()
		c.queue_free()

	var simultaneous_scene = preload("res://Scenes/GameOver.tscn").instantiate()
	find_child("gameContainer").add_child(simultaneous_scene)

func return_from_game_session() -> void:
	var gameContainer = find_child("gameContainer")
	for c in gameContainer.get_children():
		c.hide()
		c.queue_free()
	gameContainer.hide()
	find_child("menuContainer").show()
