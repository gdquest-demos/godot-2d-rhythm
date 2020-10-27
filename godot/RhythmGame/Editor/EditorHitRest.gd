tool
extends Node2D

export (int, 1, 4) var beat_duration := 2 setget set_beat_duration

var beat_number := 1


func _enter_tree() -> void:
	beat_number = get_index() + 1
	$BeatNumber.text = str(beat_number)


func _draw():
	draw_circle(Vector2.ZERO, 75.0, Color.black)


func get_data() -> Dictionary:
	return {beat_duration = beat_duration}


func set_beat_duration(amount : int) -> void:
	beat_duration = amount
	$Sprite.frame = beat_duration - 1
