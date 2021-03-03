tool
extends Path2D

export (PackedScene) var scene
export (int, 1, 4) var duration := 4 setget set_duration

var _order_number := 1


func _enter_tree() -> void:
	_order_number = get_index() + 1

	$BeatNumber.text = str(_order_number)
	$Sprite.global_position = to_global(curve.get_point_position(0))


func _ready() -> void:
	curve = curve.duplicate(false)


func get_data() -> Dictionary:
	return {
		scene = scene,
		order_number = _order_number,
		duration = duration,
		position = position,
		global_position = global_position,
		curve = curve
	}


func _draw() -> void:
	draw_circle(curve.get_point_position(0), 75.0, Color.black)
	draw_circle(curve.get_point_position(curve.get_point_count() - 1), 75.0, Color.black)


func set_duration(amount: int) -> void:
	duration = amount
	$Sprite.frame = duration - 1
