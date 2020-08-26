extends Node

export var enabled := true
export var pattern_count := 20
export var beat_delay := 12

onready var patterns = $Patterns

var track = []

var scenes = {
	"hit_beat": preload("res://src/Hits/HitBeat.tscn"),
	"hit_roller": preload("res://src/Hits/HitRoller.tscn")
}


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")

	_create_track()


func _spawn_beat(_msg: Dictionary) -> void:
	if not enabled:
		return

	if not _msg.has("beat_number"):
		return

	var _beat_number = _msg["beat_number"]

	if _beat_number <= beat_delay:
		return

	var _beat = track.pop_front()

	if not _beat:
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	if _msg.has("bps"):
		_beat["bps"] = _msg["bps"]

	if _beat.has("scene"):
		var _new_beat = scenes[_beat["scene"]].instance()
		add_child(_new_beat)
		_new_beat.initialize(_beat)


func _create_track() -> void:
	var _pattern_number = patterns.get_children().size()

	for i in range(pattern_count):
		var _pattern = patterns.get_child(i % _pattern_number)
		var _color = Colors.get_random_color()

		for _beat in _pattern.get_children():
			var _beat_data = _beat.get_data()
			_beat_data["color"] = _color
			track.append(_beat_data)

	patterns.free()
