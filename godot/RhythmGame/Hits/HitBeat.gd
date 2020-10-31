extends Node2D

export var score_perfect := 10
export var score_great := 5
export var score_ok := 3

var beat_number := 0 setget set_beat_number

var _beat_delay := 4.0  #beats before perfect
var _beat_hit := false
var _bps := 60.0 / 124.0
var _speed := 1.0 / _bps / _beat_delay

var _radius_start := 150.0
var _radius := _radius_start
var _radius_perfect := 70.0  #(150 - TargetCircle width) / 2.0

var _offset_perfect := 4
var _offset_great := 8
var _offset_ok := 16
var _offset_miss := 17

onready var _animation_player := $AnimationPlayer
onready var _sprite := $Sprite
onready var _touch_area := $Area2D
onready var _target_circle := $TargetCircle


func _ready() -> void:
	_animation_player.play("show")


func setup(data: Dictionary) -> void:
	self.beat_number = data.beat_number

	_bps = data.bps
	_speed = 1.0 / _bps / _beat_delay

	global_position = data.global_position

	_sprite.frame = data.color

	_target_circle.set_up(_radius_start, _radius_perfect, _bps, _beat_delay)
	_target_circle.global_position = global_position


func set_beat_number(number: int) -> void:
	beat_number = number
	$Label.text = str(beat_number)


func _process(delta: float) -> void:
	_radius -= delta * (_radius_start - _radius_perfect) * _speed
	update()

	if _radius <= _radius_perfect - _offset_perfect:
		_touch_area.collision_layer = 0

		if not _beat_hit:
			Events.emit_signal("scored", {"score": 0, "position": global_position})
			_animation_player.play("destroy")
			_beat_hit = true


func _get_score() -> int:
	if abs(_radius_perfect - _radius) < _offset_perfect:
		return score_perfect
	elif abs(_radius_perfect - _radius) < _offset_great:
		return score_great
	elif abs(_radius_perfect - _radius) < _offset_ok:
		return score_ok
	return 0


func _on_Area2D_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("touch"):
		Events.emit_signal("scored", {"score": _get_score(), "position": global_position})
		_beat_hit = true
		_touch_area.collision_layer = 0
		_animation_player.play("hide")
