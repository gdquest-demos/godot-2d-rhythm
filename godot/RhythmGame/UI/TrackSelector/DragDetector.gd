extends Area2D
class_name Dragger

signal dragged(amount)

export var strength := 2.0

var _dragging := false
var _start_position := Vector2()


func _start_detection(position: Vector2) -> void:
	_dragging = true
	_start_position = position


func _end_detection(position: Vector2) -> void:
	var amount: Vector2 = position - _start_position  #.normalized()
	_start_position = position
	emit_signal("dragged", amount * strength)


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("touch"):
		_start_detection(event.position)

	if event.is_action_released("touch"):
		_dragging = false

	if _dragging and event is InputEventMouseMotion:
		_end_detection(event.position)


func _on_mouse_exited() -> void:
	_dragging = false
