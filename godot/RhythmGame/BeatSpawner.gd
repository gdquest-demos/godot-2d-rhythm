extends Node

export var enabled := true

var _stacks = {}
var _stack_current = []

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")
	Events.connect("track_selected", self, "_select_stack")
	_load_tracks()


func _spawn_beat(msg: Dictionary) -> void:
	if not enabled:
		return

	if _stack_current.empty():
		enabled = false
		Events.emit_signal("track_finished", {})
		return

	var hit_beat_data: Dictionary = _stack_current.pop_front()

	if not hit_beat_data.has("scene"):
		return

	hit_beat_data.bps = msg.bps

	var new_beat: Node = hit_beat_data.scene.instance()
	add_child(new_beat)

	new_beat.setup(hit_beat_data)


func _load_tracks() -> void:
	for track in patterns.get_children():
		_stacks[track.name] = {"beats": []}

		for bar in track.get_children():
			var sprite_frame := int(rand_range(0, 5))
			for beat in bar.get_children():
				var hit_beat_data: Dictionary = beat.get_data()
				hit_beat_data.color = sprite_frame
				_stacks[track.name]["beats"].append(hit_beat_data)

				# Add additional rests if needed
				for _i in range(hit_beat_data.duration - 1):
					_stacks[track.name]["beats"].append({})
	
	patterns.queue_free()


func _select_stack(msg: Dictionary) -> void:
	_stack_current = _stacks[msg.name].beats
