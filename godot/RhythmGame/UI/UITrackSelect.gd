extends MarginContainer

var _track_index := 0

export (Array, Resource) var tracks : Array

onready var track_name := $VBoxContainer/Name
onready var track_bpm := $VBoxContainer/HSplitContainer/BPM
onready var track_icon := $VBoxContainer/HSplitContainer/Icon
onready var track_artist := $VBoxContainer/HSplitContainer/Artist


func _ready() -> void:
	_update()


func _update() -> void:
	var _data = tracks[_track_index].get_data()
	track_name.text = _data.name
	track_icon.texture = _data.icon
	track_bpm.text = "%s bpm" % _data.bpm
	track_artist.text = _data.artist


func _on_ButtonPlay_pressed() -> void:
	Events.emit_signal("track_selected", tracks[_track_index].get_data())
	visible = false


func _on_ButtonPrevious_pressed() -> void:
	_track_index = max(0, _track_index - 1)
	_update()


func _on_ButtonNext_pressed() -> void:
	_track_index = min(tracks.size() - 1, _track_index + 1)
	_update()
