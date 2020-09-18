extends Node2D

export var beat_number := 0 setget set_beat_number

var beat_hit := false
var bps := 60.0 / 124.0
var beat_delay := 4.0  #beats before perfect
var speed := 1.0 / bps / beat_delay

var radius_start := 124.0
var radius := radius_start
var radius_perfect := 64.0

var offset_perfect := 3
var offset_good := 6
var offset_ok := 18
var offset_miss := 19

var fill_color := Color.white

var score := 0

onready var animation_player := $AnimationPlayer
onready var touch_area := $Area2D
onready var target_circle := $TargetCircle


func _ready() -> void:
	animation_player.play("show")


func setup(data: Dictionary) -> void:
	self.beat_number = data.beat_number

	bps = data.bps
	speed = 1.0 / bps / beat_delay

	global_position = data.global_position

	fill_color = data.color

	target_circle.set_up(150, radius_perfect, bps, beat_delay)
	target_circle.fill_color = fill_color
	target_circle.global_position = global_position


func set_beat_number(number: int) -> void:
	beat_number = number
	$Label.text = str(beat_number)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius_perfect, fill_color)
	draw_arc(Vector2.ZERO, radius_perfect, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)


func _process(delta: float) -> void:
	radius -= delta * (radius_start - radius_perfect) * speed
	update()

	if radius <= radius_perfect - offset_perfect:
		touch_area.collision_layer = 0

		if not beat_hit:
			animation_player.play("destroy")
			Events.emit_signal("scored", {"score": 0, "position": global_position})
			beat_hit = true


func _get_score() -> int:
	if abs(radius_perfect - radius) < offset_perfect:
		return 10
	elif abs(radius_perfect - radius) < offset_good:
		return 5
	elif abs(radius_perfect - radius) < offset_ok:
		return 3
	return 0


func _on_Area2D_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("touch"):
		Events.emit_signal("scored", {"score": _get_score(), "position": global_position})
		beat_hit = true
		touch_area.collision_layer = 0
		animation_player.play("hide")
