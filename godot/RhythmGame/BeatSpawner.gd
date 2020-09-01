extends Node


export var enabled := true
export var pattern_count := 20
export var beat_delay := 12

export var hit_beat: PackedScene
export var hit_roller: PackedScene

var track = []

onready var scenes = {
	"hit_beat": hit_beat,
	"hit_roller": hit_roller
}

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")
	_create_track()


func _spawn_beat(msg: Dictionary) -> void:
	if not enabled or msg.beat_number <= beat_delay:
		return

	if track.empty():
		enabled = false
		Events.emit_signal("track_finished", {})
		return
		
	var _beat: Dictionary = track.pop_front()

	if not _beat.has("scene"):
		return

	_beat.bps = msg.bps

	var _new_beat: Node = scenes[_beat.scene].instance()
	add_child(_new_beat)

	_new_beat.setup(_beat)


func _create_track() -> void:
	var _pattern_number: int = patterns.get_children().size()

	for i in range(pattern_count):
		var _pattern: Node = patterns.get_child(i % _pattern_number)
		var _color := Colors.get_random_color()

		for _beat in _pattern.get_children():
			var _beat_data: Dictionary = _beat.get_data()
			_beat_data.color = _color
			track.append(_beat_data)

	patterns.queue_free()
