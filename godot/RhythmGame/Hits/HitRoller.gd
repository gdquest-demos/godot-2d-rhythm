extends Path2D

export var beat_number := 0 setget set_beat_number
export var beat_duration := 2.0

var bps := 0.0
var beat_delay := 4.0  #beats before roller start
var speed := 0.0
var player_tracking := false
var moving := false
var segments := 10
var _path_start := Vector2.ZERO
var _path_end := Vector2.ZERO

var radius_start := 150.0
var radius_perfect := 70.0  #(150 - TargetCircle width) / 2.0

var score := 1

onready var roller_path := $RollerPath
onready var roller := $RollerPath/Roller
onready var roller_line := $RollerLine2D
onready var sprite_first := $FirstBeatSprite
onready var label_first := $FirstBeatSprite/LabelFirstBeat
onready var sprite_second := $SecondBeatSprite
onready var roller_sprite := $RollerPath/Roller/Sprite
onready var label_second := $SecondBeatSprite/LabelSecondBeat
onready var animation_player := $AnimationPlayer
onready var start_timer := $StartTimer
onready var score_timer := $ScoreTimer
onready var target_circle := $TargetCircle


func _ready() -> void:
	animation_player.play("show")

	yield(start_timer, "timeout")
	moving = true
	roller.find_node("AnimationPlayer").play("show")
	score_timer.start(bps * beat_duration / segments / 2.0)


func _process(delta: float) -> void:
	if not moving:
		return

	roller_path.unit_offset += delta * speed

	if roller_path.unit_offset >= 1:
		_complete()


func setup(data: Dictionary) -> void:
	self.beat_number = data.beat_number

	beat_duration = data.beat_duration

	if data.has("curve"):
		curve = data.curve

	roller_path.offset = 0

	roller_line.path_points = curve.get_baked_points()

	_path_start = roller_line.path_points[0]
	_path_end = roller_line.path_points[roller_line.path_points.size() - 1]

	bps = data.bps
	speed = 2.0 / bps / beat_duration

	sprite_first.position = _path_start
	sprite_second.position = _path_end

	position = data.position

	set_sprite(data.color)

	start_timer.start(bps * beat_delay)

	target_circle.set_up(radius_start, radius_perfect, bps, beat_delay)
	target_circle.global_position = to_global(_path_start)


func set_beat_number(number: int) -> void:
	label_first.text = str(number)
	beat_number = number
	label_second.text = str(number + 1)


func set_sprite(frame: int) -> void:
	sprite_first.frame = frame
	sprite_second.frame = frame
	roller_sprite.frame = frame


func _complete() -> void:
	moving = false

	Events.emit_signal("scored", {"score": min(score, 10), "position": to_global(_path_end)})

	animation_player.play("destroy")


func _on_Area2D_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("touch"):
		player_tracking = true


func _on_Area2D_mouse_exited() -> void:
	player_tracking = false


func _on_Area2D_mouse_entered() -> void:
	if Input.is_action_pressed("touch"):
		player_tracking = true


func _on_ScoreTimer_timeout():
	if player_tracking:
		score += 1
	score_timer.start()
