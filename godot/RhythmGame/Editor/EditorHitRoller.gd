tool
extends Path2D


export (int, 1, 3) var beat_duration := 2

var beat_number := 1


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


func _on_EditorHitRoller_tree_entered() -> void:
	beat_number = get_index() + 1

	$LabelFirstBeat.text = str(beat_number)
	$LabelSecondBeat.text = str(beat_number + 1)

	$LabelSecondBeat.rect_position = (
		curve.get_point_position(curve.get_point_count() - 1)
		- Vector2.ONE * 50
	)
