extends Node

export var enabled := true

var _tracks = {}
var _track_current = []

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")
	Events.connect("track_selected", self, "_select_track")
	_load_tracks()


func _spawn_beat(msg: Dictionary) -> void:
	if not enabled:
		return

	if _track_current.empty():
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	var beat: Dictionary = _track_current.pop_front()

	if not beat.has("scene"):
		return

	beat.bps = msg.bps

	var new_beat: Node = beat.scene.instance()
	add_child(new_beat)

	new_beat.setup(beat)


func _load_tracks() -> void:
	for track in patterns.get_children():
		_tracks[track.name] = {"beats": []}

		for bar in track.get_children():
			var sprite_frame := int(rand_range(0, 5))
			for beat in bar.get_children():
				var beat_data: Dictionary = beat.get_data()
				beat_data.color = sprite_frame
				_tracks[track.name]["beats"].append(beat_data)

				# Add additional rests if needed
				for _i in range(beat_data.duration - 1):
					_tracks[track.name]["beats"].append({})
	
	patterns.queue_free()


func _select_track(msg: Dictionary) -> void:
	_track_current = _tracks[msg.name].beats
