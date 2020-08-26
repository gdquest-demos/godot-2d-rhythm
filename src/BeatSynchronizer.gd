extends Node

export var bpm := 124
export var start_delay := 0.0

onready var stream := $AudioStreamPlayer

var time_delay := 0.0
var bps := 60.0 / bpm
var last_beat := 0
var last_time := 0.0


func play_audio() -> void:
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	stream.play()


func _process(delta: float) -> void:
	var time: float = (
		stream.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	last_time = time
	var beat := int(time / bps) + 1
	if beat > last_beat:
		last_beat = beat
		Events.emit_signal("beat_incremented", {"beat_number": beat, "bps": bps})
