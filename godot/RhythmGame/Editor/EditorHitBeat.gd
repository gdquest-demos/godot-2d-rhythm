tool
extends Position2D

export (int, 1, 4) var half_beats := 2 setget set_half_beats

var beat_number := 1


func _enter_tree() -> void:
	beat_number = get_index() + 1
	$BeatNumber.text = str(beat_number)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 75.0, Color.black)


func get_data() -> Dictionary:
	return {
		scene = "hit_beat",
		beat_number = beat_number,
		global_position = global_position,
		beat_duration = half_beats
	}


func set_half_beats(amount: int) -> void:
	half_beats = amount
	$Sprite.frame = half_beats - 1
