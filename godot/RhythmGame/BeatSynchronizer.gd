extends Node

export var bpm := 124

var _bps := 60.0 / bpm
var _hbps := _bps * 0.5 # half beats per second
var _last_half_beat := 0

onready var _stream := $AudioStreamPlayer


func _ready() -> void:
	Events.connect("track_selected", self, "_load_track")


func play_audio() -> void:
	var time_delay := AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	yield(get_tree().create_timer(time_delay), "timeout")

	_stream.play()


func _process(_delta: float) -> void:
	var time: float = (
		_stream.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	
	var half_beat := int(time / _hbps)

	if half_beat > _last_half_beat:
		_last_half_beat = half_beat
		Events.emit_signal("beat_incremented", {"half_beat" : half_beat, "bps": _bps})


func _load_track(msg: Dictionary) -> void:
	_stream.stream = load(msg.stream)
	bpm = msg.bpm
	_bps = 60.0 / bpm
	_hbps = _bps * 0.5
	play_audio()
