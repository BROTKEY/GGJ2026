extends Node2D

var attack_timer: Timer;
var reveal_timer: Timer;
var sprite: AnimatedSprite2D;

var playerHasScrewedUp = false
var defeated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = find_child("AttackTimer")
	reveal_timer = find_child("RevealTimer")
	sprite = find_child("AnimatedSprite2D")
	sprite.hide()
	
func ActivateMonster() -> void:
	sprite.play("default")
	sprite.show()
	attack_timer.start()

func MonsterRevealed() -> void:
	pass

func TriggerJumpscare() -> void:
	sprite.play("jumpscare")
	
	sprite.apply_scale(Vector2(5, 5))
	playerHasScrewedUp = true

func make_defeat() -> void:
	defeated = true
	attack_timer.stop()
	reveal_timer.stop()
	sprite.play("dying")

func AnimationFinished() -> void:
	# TODO go to game over
	if playerHasScrewedUp:
		var container = get_node("/root/MainMenu")
		container.show_game_over()
	
	if defeated:
		var firstperson = get_parent().get_parent()
		firstperson.hide()
		firstperson.queue_free()
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if playerHasScrewedUp:
	pass
