extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var monsters = find_children("Monster*")
	monsters.get(monsters.size() * randf()).ActivateMonster()
