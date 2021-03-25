class_name TrackTile
extends Area2D

var _data: TrackData


func setup(track_data: TrackData):
	_data = track_data
	$Sprite.texture = _data.icon


func get_data() -> TrackData:
	return _data
