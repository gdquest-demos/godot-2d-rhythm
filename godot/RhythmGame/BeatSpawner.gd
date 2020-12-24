extends Node

export var enabled := true

export var hit_beat: PackedScene
export var hit_roller: PackedScene

var _tracks = {}
var _track_current = []
var _delay_start := 0

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
	if not enabled or msg.half_beat <= _delay_start:
		return

	if _track_current.empty():
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	var beat: Dictionary = _track_current.pop_front()

	if not beat.has("scene"):
		return

	beat.bps = msg.bps

	var new_beat: Node = scenes[beat.scene].instance()
	add_child(new_beat)

	new_beat.setup(beat)


func _load_tracks() -> void:
	for track in patterns.get_children():
		_tracks[track.name] = {"delay_start": track.delay_start, "beats": []}

		for bar in track.get_children():
			var sprite_frame := int(rand_range(0, 5))
			for beat in bar.get_children():
				var beat_data: Dictionary = beat.get_data()
				beat_data.color = sprite_frame
				_tracks[track.name]["beats"].append(beat_data)

				# Add additional rests if needed
				for _i in range(beat_data.beat_duration - 1):
					_tracks[track.name]["beats"].append({})
	
	patterns.queue_free()


func _select_track(msg: Dictionary) -> void:
	_track_current = _tracks[msg.name].beats
	_delay_start = _tracks[msg.name].delay_start
