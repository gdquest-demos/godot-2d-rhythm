extends Control

var _track_info: Dictionary

onready var track_name := $TrackName
onready var stream := $AudioStreamPlayer
onready var animation_player := $AnimationPlayer


func update_track_info(track_tile) -> void:
	_track_info = track_tile.get_data()
	track_name.text = _track_info.name
	animation_player.play("fade_out_track")
	yield(animation_player, "animation_finished")
	stream.stream = load(_track_info.stream)
	stream.play(30.0)
	animation_player.play("fade_in_track")


func _on_GoButton_pressed() -> void:
	Events.emit_signal("track_selected", _track_info)
	queue_free()
