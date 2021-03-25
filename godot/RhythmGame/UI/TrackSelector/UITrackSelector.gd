extends Control

var _current_track_data: TrackData

onready var _track_name := $TrackName
onready var _stream := $AudioStreamPlayer
onready var _animation_player := $AnimationPlayer


func update_track_info(track_tile) -> void:
	_current_track_data = track_tile.get_data()
	_track_name.text = _current_track_data.label

	_animation_player.play("fade_out_track")
	yield(_animation_player, "animation_finished")
	_stream.stream = load(_current_track_data.stream)
	_stream.play(30.0)
	_animation_player.play("fade_in_track")


func _on_GoButton_pressed() -> void:
	Events.emit_signal("track_selected", _current_track_data.as_dict())
	queue_free()
