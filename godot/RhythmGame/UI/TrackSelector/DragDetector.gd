extends Area2D
class_name DragDetector

signal dragged(amount)

export var strength := 2.0


func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("touch"):
		emit_signal("dragged", event.relative * strength)
