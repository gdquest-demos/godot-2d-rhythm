extends Node2D

export var beat_number := 0 setget set_beat_number

var beat_hit := false
var bps := 60.0 / 124.0
var beat_delay := 4.0  #beats before perfect
var speed := 1.0 / bps / beat_delay

var radius_start := 150.0
var radius := radius_start
var radius_perfect := 70.0  #(150 - TargetCircle width) / 2.0

var offset_perfect := 4
var offset_good := 8
var offset_ok := 16
var offset_miss := 17

var score := 0

onready var animation_player := $AnimationPlayer
onready var sprite := $Sprite
onready var touch_area := $Area2D
onready var target_circle := $TargetCircle


func _ready() -> void:
	animation_player.play("show")


func setup(data: Dictionary) -> void:
	self.beat_number = data.beat_number

	bps = data.bps
	speed = 1.0 / bps / beat_delay

	global_position = data.global_position

	sprite.frame = data.color

	target_circle.set_up(radius_start, radius_perfect, bps, beat_delay)
	target_circle.global_position = global_position


func set_beat_number(number: int) -> void:
	beat_number = number
	$Label.text = str(beat_number)


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
