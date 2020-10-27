tool
extends Node2D

export (int, 1, 4) var half_beats := 2 setget set_half_beats

var beat_number := 1


func _enter_tree() -> void:
	beat_number = get_index() + 1
	$BeatNumber.text = str(beat_number)


func _draw():
	draw_circle(Vector2.ZERO, 75.0, Color.black)


func get_data() -> Dictionary:
	return {beat_duration = half_beats}


func set_half_beats(amount : int) -> void:
	half_beats = amount
	$Sprite.frame = half_beats - 1
