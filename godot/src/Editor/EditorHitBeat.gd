tool
extends Position2D

var beat_number := 1 setget set_beat_number, _get_beat_number


func _draw() -> void:
	draw_circle(Vector2.ZERO, 64.0, Colors.BLUE)


func get_data() -> Dictionary:
	var _data = {
		"scene": "hit_beat",
		"beat_number": beat_number,
		"global_position": global_position,
		"color": Colors.BLUE
	}
	return _data


func set_beat_number(_no: int) -> void:
	beat_number = _no
	$BeatNumber.text = str(_no)


func _get_beat_number() -> int:
	return beat_number


func _on_EditorHitBeat_tree_entered() -> void:
	self.beat_number = get_index() + 1
