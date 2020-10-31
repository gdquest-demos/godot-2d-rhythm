extends Control

var _track_info: Dictionary

onready var _track_name := $TrackName
onready var _stream := $AudioStreamPlayer
onready var _animation_player := $AnimationPlayer


func update_track_info(track_tile) -> void:
	_track_info = track_tile.get_data()
	_track_name.text = _track_info.name
	_animation_player.play("fade_out_track")
	yield(_animation_player, "animation_finished")
	_stream.stream = load(_track_info.stream)
	_stream.play(30.0)
	_animation_player.play("fade_in_track")


func _on_GoButton_pressed() -> void:
	Events.emit_signal("track_selected", _track_info)
	queue_free()
