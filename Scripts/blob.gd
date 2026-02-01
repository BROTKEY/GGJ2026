extends Node2D

var attack_timer: Timer;
var sprite: AnimatedSprite2D;

var playerHasScrewedUp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = find_child("AttackTimer")
	sprite = find_child("AnimatedSprite2D")
	sprite.hide()
	
func ActivateMonster() -> void:
	sprite.animation = "default"
	sprite.show()
	attack_timer.start()
	print("ok")

func MonsterRevealed() -> void:
	pass

func TriggerJumpscare() -> void:
	sprite.play("jumpscare")
	
	sprite.apply_scale(Vector2(5, 5))
	playerHasScrewedUp = true
	

func AnimationFinished() -> void:
	# TODO go to game over
	if playerHasScrewedUp:
		var simultaneous_scene = preload("res://Scenes/GameOver.tscn").instantiate()
		var container = get_tree().find_child("gameContainer", true)
		container.get_child(0).queue_free()
		container.add_child(simultaneous_scene)
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if playerHasScrewedUp:
	pass
