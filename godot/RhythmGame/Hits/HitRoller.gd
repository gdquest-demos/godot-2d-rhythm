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

var fill_color = Colors.WHITE

var score := 1

onready var roller_path := $RollerPath
onready var roller := $RollerPath/Roller
onready var roller_line := $RollerLine2D
onready var label_first := $LabelFirstBeat
onready var label_second := $LabelSecondBeat
onready var animation_player := $AnimationPlayer
onready var start_timer := $StartTimer
onready var timer := $Timer
onready var target_circle := $TargetCircle


func _ready() -> void:
	animation_player.play("show")

	yield(start_timer, "timeout")
	moving = true
	timer.start(bps * beat_duration / segments)


func _draw() -> void:
	draw_circle(_path_start, 64.0, fill_color)
	draw_arc(_path_start, 64.0, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)

	draw_circle(_path_end, 64.0, fill_color)
	draw_arc(_path_end, 64.0, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)


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
	speed = 1.0 / bps / beat_duration

	label_first.rect_position = _path_start - Vector2.ONE * 50
	label_second.rect_position = _path_end - Vector2.ONE * 50

	position = data.position

	set_color(data.color)

	start_timer.start(bps * beat_delay)

	target_circle.set_up(128.0, 64.0, bps, beat_delay)
	target_circle.fill_color = fill_color
	target_circle.global_position = to_global(_path_start)


func set_beat_number(number: int) -> void:
	label_first.text = str(number)
	beat_number = number
	label_second.text = str(number + 1)


func set_color(color: Color) -> void:
	fill_color = color
	roller.fill_color = color
	roller_line.default_color = color


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


func _on_Timer_timeout() -> void:
	if player_tracking:
		score += 1
	timer.start()
