tool
extends Path2D

export (int, 1, 4) var half_beats := 4 setget set_half_beats

var _beat_number := 1


func _enter_tree() -> void:
	_beat_number = get_index() + 1

	$BeatNumber.text = str(_beat_number)
	$Sprite.global_position = to_global(curve.get_point_position(0))


func _ready() -> void:
	curve = curve.duplicate(false)


func get_data() -> Dictionary:
	return {
		scene = "hit_roller",
		beat_number = _beat_number,
		beat_duration = half_beats,
		position = position,
		global_position = global_position,
		curve = curve
	}


func _draw() -> void:
	draw_circle(curve.get_point_position(0), 75.0, Color.black)
	draw_circle(curve.get_point_position(curve.get_point_count() - 1), 75.0, Color.black)


func set_half_beats(amount: int) -> void:
	half_beats = amount
	$Sprite.frame = half_beats - 1
