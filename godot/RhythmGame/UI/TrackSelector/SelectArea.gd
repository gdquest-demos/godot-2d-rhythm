extends Area2D

signal track_selected(track_tile)

var _last_tile_selected = null


func _on_area_entered(track_tile) -> void:
	if _last_tile_selected != track_tile:
		emit_signal("track_selected", track_tile)
	_last_tile_selected = track_tile
