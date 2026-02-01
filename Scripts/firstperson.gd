extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_variant(type: String) -> void:
	print(type)
	if type == "Comode":
		var simultaneous_scene = preload("res://Scenes/firstperson/Comode.tscn").instantiate()
		add_child(simultaneous_scene)
	elif type == "Comode2":
		var simultaneous_scene = preload("res://Scenes/firstperson/Comode2.tscn").instantiate()
		add_child(simultaneous_scene)
	elif type == "Table":
		var simultaneous_scene = preload("res://Scenes/firstperson/Table.tscn").instantiate()
		add_child(simultaneous_scene)
