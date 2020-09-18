extends Node

export var enabled := true

export var hit_beat: PackedScene
export var hit_roller: PackedScene

var tracks = {}
var track_current = []
var delay_start := 0

onready var scenes = {
	"hit_beat": hit_beat, 
	"hit_roller": hit_roller
}

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")
	Events.connect("track_selected", self, "_select_track")
	_load_tracks()


func _spawn_beat(msg: Dictionary) -> void:
	if not enabled or msg.beat_number <= delay_start:
		return

	if track_current.empty():
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	var _beat: Dictionary = track_current.pop_front()

	if not _beat.has("scene"):
		return

	_beat.bps = msg.bps

	var _new_beat: Node = scenes[_beat.scene].instance()
	add_child(_new_beat)

	_new_beat.setup(_beat)


func _load_tracks() -> void:
	for _track in patterns.get_children():
		tracks[_track.name] = {"delay_start": _track.delay_start, "beats": []}

		for _bar in _track.get_children():
			var _color := Colors.get_random_color()
			for _beat in _bar.get_children():
				var _beat_data: Dictionary = _beat.get_data()
				_beat_data.color = _color
				tracks[_track.name]["beats"].append(_beat_data)

				# Add additional rests if needed
				for i in range(_beat_data.beat_duration - 1):
					tracks[_track.name]["beats"].append({})

	patterns.queue_free()


func _select_track(msg: Dictionary) -> void:
	track_current = tracks[msg.name].beats
	delay_start = tracks[msg.name].delay_start
