tool
extends Position2D

var beat_number := 1


func _draw() -> void:
	draw_circle(Vector2.ZERO, 64.0, Colors.BLACK)


func get_data() -> Dictionary:
	return {scene = "hit_beat", beat_number = beat_number, global_position = global_position}


func _on_EditorHitBeat_tree_entered() -> void:
	beat_number = get_index() + 1
	$BeatNumber.text = str(beat_number)
