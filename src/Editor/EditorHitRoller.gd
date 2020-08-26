tool
extends Path2D

export (int, 1, 3) var beat_duration := 2

var beat_number := 1 setget set_beat_number, _get_beat_number


func _ready() -> void:
	curve = curve.duplicate(false)


func get_data() -> Dictionary:
	var _data = {
		"scene": "hit_roller",
		"beat_number": beat_number,
		"beat_duration": beat_duration,
		"position": position,
		"global_position": global_position,
		"curve": curve,
		"color": Colors.BLUE
	}
	return _data


func _draw() -> void:
	draw_circle(curve.get_point_position(0), 64.0, Colors.BLUE)
	draw_circle(curve.get_point_position(curve.get_point_count() - 1), 64.0, Colors.BLUE)


func set_beat_number(_no: int) -> void:
	beat_number = _no
	$LabelFirstBeat.text = str(_no)
	$LabelSecondBeat.text = str(_no + 1)


func _get_beat_number() -> int:
	return beat_number


func _on_EditorHitRoller_tree_entered() -> void:
	self.beat_number = get_index() + 1
	$LabelSecondBeat.rect_position = (
		curve.get_point_position(curve.get_point_count() - 1)
		- Vector2.ONE * 50
	)
