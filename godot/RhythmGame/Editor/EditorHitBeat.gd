tool
extends Position2D

export (PackedScene) var scene
export (int, 1, 4) var duration := 2 setget set_duration

var _order_number := 1


func _enter_tree() -> void:
	_order_number = get_index() + 1
	$OrderNumber.text = str(_order_number)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 75.0, Color.black)
	

func get_data() -> Dictionary:
	return {
		scene = scene,
		order_number = _order_number,
		global_position = global_position,
		duration = duration
	}


func set_duration(amount: int) -> void:
	duration = amount
	$Sprite.frame = duration - 1
