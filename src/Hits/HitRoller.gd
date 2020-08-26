extends Path2D

export var beat_number := 0 setget set_beat_number
export var show_delay := 0
export var beat_duration := 2.0

onready var roller_path := $RollerPath
onready var roller := $RollerPath/Roller
onready var roller_line := $RollerLine2D
onready var label_first := $LabelFirstBeat
onready var label_second := $LabelSecondBeat
onready var start_beat := $Beat
onready var animation_player := $AnimationPlayer
onready var timer := $Timer

var bps := 60.0 / 124
var player_tracking := false
var moving := false
var segments := 10
var _path_start := Vector2.ZERO
var _path_end := Vector2.ZERO

var fill_color := Colors.ORANGE

var score := 1


func _ready() -> void:
	animation_player.play("show")

	yield(start_beat, "beat_aligned")
	moving = true
	timer.start(bps * beat_duration / segments)


func initialize(_dict: Dictionary) -> void:
	if _dict.has("beat_number"):
		self.beat_number = _dict["beat_number"]

	if _dict.has("beat_duration"):
		beat_duration = _dict["beat_duration"]

	if _dict.has("curve"):
		curve = _dict["curve"]

	roller_path.offset = 0

	roller_line.path_points = curve.get_baked_points()

	_path_start = roller_line.path_points[0]
	_path_end = roller_line.path_points[roller_line.path_points.size() - 1]

	if _dict.has("bps"):
		bps = _dict["bps"]
		start_beat.bps = _dict["bps"]

	start_beat.position = _path_start

	label_first.rect_position = _path_start - Vector2.ONE * 50
	label_second.rect_position = _path_end - Vector2.ONE * 50

	if _dict.has("position"):
		position = _dict["position"]

	if _dict.has("color"):
		set_color(_dict["color"])


func set_beat_number(_no: int) -> void:
	start_beat.set_beat_number(_no)
	label_first.text = str(_no)
	beat_number = _no
	label_second.text = str(_no + 1)


func set_color(color: Color) -> void:
	fill_color = color
	roller.fill_color = color
	start_beat.set_color(color)
	roller_line.default_color = color


func _draw() -> void:
	draw_circle(_path_start, 64.0, fill_color)
	draw_arc(_path_start, 64.0, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)

	draw_circle(_path_end, 64.0, fill_color)
	draw_arc(_path_end, 64.0, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)


func get_speed() -> float:
	return 1.0 / bps / beat_duration


func _process(delta: float) -> void:
	if not moving:
		return

	roller_path.unit_offset += delta * get_speed()

	if roller_path.unit_offset >= 1:
		_complete()


func _complete() -> void:
	moving = false

	if player_tracking:
		Events.emit_signal("scored", {"score": min(score, 10)})

	animation_player.play("destroy")


func _on_Area2D_input_event(viewport, event, shape_idx) -> void:
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
