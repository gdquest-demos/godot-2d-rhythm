tool
extends Position2D

var beat_number := 1


func _enter_tree() -> void:
	beat_number = get_index() + 1
	$BeatNumber.text = str(beat_number)


func _draw() -> void:
	draw_circle(Vector2.ZERO, 64.0, Colors.BLACK)


func get_data() -> Dictionary:
	return {
		scene = "hit_beat", beat_number = beat_number, global_position = global_position
	}
