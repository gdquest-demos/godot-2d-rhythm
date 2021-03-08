extends Node

export var enabled := true

var _stacks = {}
var _stack_current = []

onready var patterns = $Patterns


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")
	Events.connect("track_selected", self, "_select_stack")
	_generate_stacks()


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


func _generate_stacks() -> void:
	for pattern in patterns.get_children():
		
		_stacks[pattern.name] = []

		for chunk in pattern.get_children():
			var sprite_frame := int(rand_range(0, 5))
			
			for placer in chunk.get_children():
				var hit_beat_data: Dictionary = placer.get_data()
				hit_beat_data.color = sprite_frame
				_stacks[pattern.name].append(hit_beat_data)

				# Add additional rests if needed
				for _i in range(hit_beat_data.duration - 1):
					_stacks[pattern.name].append({})
	
	patterns.queue_free()


func _select_stack(msg: Dictionary) -> void:
	_stack_current = _stacks[msg.name]
