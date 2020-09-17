extends Position2D

export var shrink_speed := 0.0

var radius := 0.0
var end_radius := 0.0
var fill_color := Colors.WHITE

onready var animation_player := $AnimationPlayer


func set_up(radius_start: float, radius_end: float, bps: float, beat_delay: float) -> void:
	radius = radius_start
	end_radius = radius_end
	shrink_speed = 1.0 / bps / beat_delay * (radius - end_radius)


func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0.0, 2 * PI, 100, fill_color, 6.0, true)


func _process(delta: float) -> void:
	radius -= delta * shrink_speed
	if radius <= end_radius and shrink_speed > 0.0:
		radius = end_radius
		animation_player.play("destroy")
	update()
