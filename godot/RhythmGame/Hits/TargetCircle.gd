extends Position2D

const THICKNESS := 0.015

export var shrink_speed := 0.0

var radius := 0.0
var end_radius := 0.0
var fill_color := Colors.WHITE
var max_radius := 0.0

onready var animation_player := $AnimationPlayer
onready var target_circle := $TargetCircle


func set_up(radius_start: float, radius_end: float, bps: float, beat_delay: float) -> void:
	radius = radius_start
	end_radius = radius_end
	max_radius = radius
	shrink_speed = 1.0 / bps / beat_delay * (radius - end_radius)

	target_circle.margin_left = -radius
	target_circle.margin_right = radius
	target_circle.margin_top = -radius
	target_circle.margin_bottom = radius

	target_circle.rect_size = Vector2.ONE * radius * 2
	target_circle.material = target_circle.material.duplicate()


func _process(delta: float) -> void:
	radius -= delta * shrink_speed
	if radius <= end_radius and shrink_speed > 0.0:
		radius = end_radius
		animation_player.play("destroy")
	target_circle.material.set_shader_param("torus_radius", radius / max_radius / 2)
