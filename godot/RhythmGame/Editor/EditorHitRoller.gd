tool
extends Path2D

export (int, 1, 4) var beat_duration := 4 setget set_beat_duration

var beat_number := 1


func _enter_tree() -> void:
	beat_number = get_index() + 1

	$BeatNumber.text = str(beat_number)

	$Sprite.global_position = to_global(curve.get_point_position(0))


func _ready() -> void:
	curve = curve.duplicate(false)


func get_data() -> Dictionary:
	return {
		scene = "hit_roller",
		beat_number = beat_number,
		beat_duration = beat_duration,
		position = position,
		global_position = global_position,
		curve = curve
	}


func _draw() -> void:
	draw_circle(curve.get_point_position(0), 64.0, Colors.BLACK)
	draw_circle(curve.get_point_position(curve.get_point_count() - 1), 64.0, Colors.BLACK)


func set_beat_duration(amount: int) -> void:
	beat_duration = amount
	$Sprite.frame = beat_duration - 1
