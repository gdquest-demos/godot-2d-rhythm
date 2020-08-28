extends Node

export var enabled := true
export var pattern_count := 20
export var beat_delay := 12

var track = []

var scenes = {
	"hit_beat": preload("res://RhythmGame/Hits/HitBeat.tscn"),
	"hit_roller": preload("res://RhythmGame/Hits/HitRoller.tscn")
}

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")

	_create_track()


func _spawn_beat(msg: Dictionary) -> void:
	if not enabled:
		return

	if msg.beat_number <= beat_delay:
		return

	var _beat = track.pop_front()

	if not _beat:
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	if not _beat.has("scene"):
		return

	_beat.bps = msg.bps

	var _new_beat = scenes[_beat.scene].instance()
	add_child(_new_beat)
	_new_beat.setup(_beat)


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
