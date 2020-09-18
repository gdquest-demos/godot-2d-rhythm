extends Node

var bpm := 124
var bps := 60.0 / bpm
var hbps := bps * 0.5 # half beats per second
var last_half_beat := 0

onready var stream := $AudioStreamPlayer


func _ready():
	Events.connect("track_selected", self, "_load_track")


func play_audio() -> void:
	var time_delay := AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	yield(get_tree().create_timer(time_delay), "timeout")

	stream.play()


func _process(_delta: float) -> void:
	var time: float = (
		stream.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)

	var half_beat := int(time / hbps)

	if half_beat > last_half_beat:
		last_half_beat = half_beat
		Events.emit_signal("beat_incremented", {"beat_number": half_beat, "bps": bps})


func _load_track(msg: Dictionary) -> void:
	stream.stream = load(msg.stream)
	bpm = msg.bpm
	bps = 60.0 / bpm
	hbps = bps * 0.5
	play_audio()
