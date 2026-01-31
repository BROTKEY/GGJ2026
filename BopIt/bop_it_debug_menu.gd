extends Control


const BOP = BopitController.BopItAction.BOP
const TWIST = BopitController.BopItAction.TWIST
const PULL = BopitController.BopItAction.PULL


@onready var LabelConnected = $AspectRatioContainer/Margin/Margin/VBoxContainer/GridContainer/Connected
@onready var LabelBopped = $AspectRatioContainer/Margin/Margin/VBoxContainer/GridContainer/Bopped
@onready var LabelTwisted = $AspectRatioContainer/Margin/Margin/VBoxContainer/GridContainer/Twisted
@onready var LabelPulled = $AspectRatioContainer/Margin/Margin/VBoxContainer/GridContainer/Pulled
@onready var LabelVolume = $AspectRatioContainer/Margin/Margin/VBoxContainer/HBoxContainer/Volume


var _backup_polling_states = null
var _do_write_volume = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_backup_polling_states = BopitController.polling_states
	BopitController.enable_polling(BOP)
	BopitController.enable_polling(TWIST)
	BopitController.enable_polling(PULL)
	BopitController.volume_received.connect(_on_volume_received)
	if not BopitController.is_bopit_connected():
		BopitController.start_scan()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var bopit_connected = BopitController.is_bopit_connected()
	LabelConnected.text = str(bopit_connected)
	if bopit_connected:
		LabelBopped.text = str(BopitController.action_flags[BOP])
		LabelTwisted.text = str(BopitController.action_flags[TWIST])
		LabelPulled.text = str(BopitController.action_flags[PULL])
		BopitController.poll_volume()


func _exit_tree() -> void:
	if _backup_polling_states != null:
		BopitController.polling_states = _backup_polling_states


func _on_bop_it_pressed() -> void:
	BopitController.play_sound(BOP)


func _on_twist_id_pressed() -> void:
	BopitController.play_sound(TWIST)


func _on_pull_it_pressed() -> void:
	BopitController.play_sound(PULL)


func _on_h_slider_value_changed(value: float) -> void:
	if _do_write_volume:
		BopitController.set_volume(int(value))

func _on_volume_received(value: int) -> void:
	_do_write_volume = false
	LabelVolume.text = str(value)
	_do_write_volume = true
