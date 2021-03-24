extends ColorRect

const THICKNESS := 0.015

var shrink_speed := 0.0

var _radius := 0.0
var _end_radius := 0.0
var _start_radius := 0.0


func _init() -> void:
	set_process(false)


func setup(radius_start: float, radius_end: float, bps: float, beat_delay: float) -> void:
	_radius = radius_start
	_end_radius = radius_end
	_start_radius = _radius
	shrink_speed = 1.0 / bps / beat_delay * (_radius - _end_radius)

	margin_left = -_radius
	margin_right = _radius
	margin_top = -_radius
	margin_bottom = _radius

	rect_size = Vector2.ONE * _radius * 2

	set_process(true)


func _process(delta: float) -> void:
	_radius -= delta * shrink_speed

	material.set_shader_param("torus_radius", _radius / _start_radius / 2)

	if _radius <= _end_radius:
		_radius = _end_radius
		shrink_speed = 0.0
		set_process(false)
