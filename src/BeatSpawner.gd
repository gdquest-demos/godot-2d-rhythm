extends Node


var track = []
var beat_scene = preload("res://src/Hits/HitBeat.tscn")
var beat_roller_scene = preload("res://src/Hits/HitRoller.tscn")


func _ready():
	Events.connect("beat_incremented", self, "_create_beat")
	_create_track()


func _create_beat(current_beat : int) -> void:
	
	var _back_beat = current_beat + 4
	
	var _pattern = randi()%1
	
	var _beat = track.pop_front()
	
	if not _beat:
		return
	
	if _beat["type"] == "normal":
		var _new_beat = beat_scene.instance()
		_new_beat.beat_number = _beat["beat_number"]
		_new_beat.global_position = _beat["position"]
		_new_beat.set_color(_beat["color"])
		add_child(_new_beat)
	
	if _beat["type"] == "roller":
		var _new_beat = beat_roller_scene.instance()
		_new_beat.beat_number = _beat["beat_number"]
		_new_beat.lifetime_beats = _beat["lifetime_beats"]
		_new_beat.global_position = _beat["position"]
		_new_beat.set_color(_beat["color"])
		var _curve = Curve2D.new()
		for _point in _beat["curve"]:
			_curve.add_point(_point)
		_new_beat.curve = _curve
		add_child(_new_beat)


func _create_track():
	# store each beat and what should be spawned on it
	# in chunks of 8, check delay
	var _pattern_amount = 20
	var _bar = 0
	for i in range(_pattern_amount):
		var _pattern = randi()%$Patterns.get_children().size()
		var _beat_time = 0
		var _color = Colors.get_random_color()
		
		for _beat in range(8):
			if _beat > $Patterns.get_child(_pattern).get_children().size() - 1:
				
				if _beat_time < 8:
					_beat_time += 1
					track.append(null)
				continue
			var _sampled_beat_data = $Patterns.get_child(_pattern).get_child(_beat).data
			_sampled_beat_data["color"] = _color
			track.append(_sampled_beat_data)
			
			for _delay in range(_sampled_beat_data["show_delay"]):
				_beat_time += 1
				track.append(null)
			
			_beat_time += 1
		
		if i % 8 == 0:
			_bar += 1
	$Patterns.free()
