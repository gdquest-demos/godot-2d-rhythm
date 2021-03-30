extends Area2D

var _score := 0
var _poll_time := 0.0
var _poll_amount := 10
var _player_in_bounds := false

onready var _score_timer := $ScoreTimer
onready var _tween := $Tween
onready var _sprite := $Sprite


func _ready() -> void:
	_sprite.scale = Vector2.ZERO


func setup(beats_per_second: float, duration: float, color: int) -> void:
	_poll_time = beats_per_second * duration / 2.0 / _poll_amount 
	
	_sprite.frame = color


func activate() -> void:
	
	_tween.interpolate_property(_sprite, "scale", 
		Vector2.ZERO, 
		Vector2.ONE, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	_tween.start()
	
	_score_timer.start(_poll_time)


func _on_ScoreTimer_timeout() -> void:
	
	if not _player_in_bounds:
		return
	
	if not Input.is_action_pressed("touch"):
		return
	
	_score += 1


func _on_mouse_entered() -> void:
	_player_in_bounds = true


func _on_mouse_exited() -> void:
	_player_in_bounds = false


func submit_score() -> void:
	Events.emit_signal("scored", {"score": _score, "position": global_position})
