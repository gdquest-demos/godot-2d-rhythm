extends Node

export var pattern_count := 20

var track = []
var scenes = {
	"hit_beat" : preload("res://src/Hits/HitBeat.tscn"),
	"hit_roller" : preload("res://src/Hits/HitRoller.tscn")
	}


func _ready():
	Events.connect("beat_incremented", self, "_spawn_beat")
	_create_track()


func _spawn_beat(_msg : Dictionary) -> void:
	
	if not _msg.has("beat_number"):
		return
	
	var _beat = track.pop_front()
	
	if not _beat:
		return
	
	var _back_beat = _msg["beat_number"] + 4
	
	if _beat.has("scene"):
		var _new_beat = scenes[_beat["scene"]].instance()
		_new_beat.initialize(_beat)
		add_child(_new_beat)


func _create_track():
	
	var _pattern_number = 0
	for i in range(pattern_count):
		
		var _pattern = $Patterns.get_child(_pattern_number)
		var _color = Colors.get_random_color()
		
		for _beat in _pattern.get_children():
			var _sampled_beat_data = _beat.get_data()
			_sampled_beat_data["color"] = _color
			track.append(_sampled_beat_data)
		
		_pattern_number = (_pattern_number + 1) % $Patterns.get_children().size()
	
	$Patterns.free()
