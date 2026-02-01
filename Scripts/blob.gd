extends Node2D

var attack_timer: Timer;
var reveal_timer: Timer;
var sprite: AnimatedSprite2D;
var bopit_action: String;

var playerHasScrewedUp = false
var defeated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer = find_child("AttackTimer")
	reveal_timer = find_child("RevealTimer")
	sprite = find_child("AnimatedSprite2D")
	sprite.hide()
	bopit_action = get_meta("BopitAction")
	
func ActivateMonster() -> void:
	sprite.play("default")
	sprite.show()
	attack_timer.start()
	$"/root/BopitController".enable_polling_all()

func MonsterRevealed() -> void:
	pass

func TriggerJumpscare() -> void:
	$"/root/BopitController".disable_polling_all()
	sprite.play("jumpscare")
	
	sprite.apply_scale(Vector2(5, 5))
	playerHasScrewedUp = true

func make_defeat() -> void:
	$"/root/BopitController".disable_polling_all()
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
		var game = get_node("/root/MainMenu/gameContainer/Game")
		firstperson.hide()
		firstperson.queue_free()
		game.return_from_firstperson()
	
	pass

enum BopItAction
{
	BOP,
	TWIST,
	PULL
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bop: bool = $"/root/BopitController".action_flags[BopItAction.BOP]
	var twist: bool = $"/root/BopitController".action_flags[BopItAction.TWIST]
	var pull: bool = $"/root/BopitController".action_flags[BopItAction.PULL]

	if Input.is_action_pressed("bop"):
		bop = true
	elif Input.is_action_pressed("twist"):
		twist = true
	elif Input.is_action_pressed("pull"):
		pull = true

	if bop:
		if bopit_action == "BOP":
			make_defeat()
		else:
			TriggerJumpscare()
	elif twist:
		if bopit_action == "TWIST":
			make_defeat()
		else:
			TriggerJumpscare()
	elif pull:
		if bopit_action == "PULL":
			make_defeat()
		else:
			TriggerJumpscare()
	pass
