extends Path2D

var order_number := 0 setget set_order_number

var _duration := 2.0
var _bps := 0.0
var _beat_delay := 4.0  #beats before roller start
var _speed := 0.0
var _player_tracking := false
var _moving := false
var _segments := 11
var _path_start := Vector2.ZERO
var _path_end := Vector2.ZERO

var _radius_start := 150.0
var _radius_perfect := 70.0  #(150 - TargetCircle width) / 2.0

var _score := 0

onready var _roller_path := $RollerPath
onready var _roller := $RollerPath/Roller
onready var _roller_line := $RollerLine2D

onready var _sprite_first := $FirstBeatSprite
onready var _label_first := $FirstBeatSprite/LabelFirstBeat
onready var _sprite_second := $SecondBeatSprite
onready var _label_second := $SecondBeatSprite/LabelSecondBeat
onready var _roller_sprite := $RollerPath/Roller/Sprite

onready var _start_timer := $StartTimer
onready var _score_timer := $ScoreTimer
onready var _target_circle := $TargetCircle
onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	_animation_player.play("show")

	yield(_start_timer, "timeout")
	_moving = true
	_roller.find_node("AnimationPlayer").play("show")
	_score_timer.start(_bps * _duration / _segments / 2.0)


func _process(delta: float) -> void:
	if not _moving:
		return

	_roller_path.unit_offset += delta * _speed

	if _roller_path.unit_offset >= 1:
		_complete()


func setup(data: Dictionary) -> void:
	self.order_number = data.order_number

	_duration = data.duration

	if data.has("curve"):
		curve = data.curve

	_roller_path.offset = 0

	_roller_line.path_points = curve.get_baked_points()

	_path_start = _roller_line.path_points[0]
	_path_end = _roller_line.path_points[_roller_line.path_points.size() - 1]

	_bps = data.bps
	_speed = 2.0 / _bps / _duration

	_sprite_first.position = _path_start
	_sprite_second.position = _path_end

	position = data.position

	set_sprite(data.color)

	_start_timer.start(_bps * _beat_delay)

	_target_circle.set_up(_radius_start, _radius_perfect, _bps, _beat_delay)
	_target_circle.global_position = to_global(_path_start)


func set_order_number(number: int) -> void:
	_label_first.text = str(number)
	order_number = number
	_label_second.text = str(number + 1)


func set_sprite(frame: int) -> void:
	_sprite_first.frame = frame
	_sprite_second.frame = frame
	_roller_sprite.frame = frame


func _complete() -> void:
	_moving = false

	Events.emit_signal("scored", {"score": min(_score, 10), "position": to_global(_path_end)})

	_animation_player.play("destroy")


func _on_Area2D_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("touch"):
		_player_tracking = true


func _on_Area2D_mouse_exited() -> void:
	_player_tracking = false


func _on_Area2D_mouse_entered() -> void:
	if Input.is_action_pressed("touch"):
		_player_tracking = true


func _on_ScoreTimer_timeout():
	if _player_tracking:
		_score += 1
	_score_timer.start()
