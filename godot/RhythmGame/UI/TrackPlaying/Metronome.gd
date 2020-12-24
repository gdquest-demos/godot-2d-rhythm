extends Sprite

var _start_scale := Vector2.ONE
var _end_scale := Vector2.ONE * 1.5

onready var _tween := $Tween


func _ready():
	Events.connect("beat_incremented", self, "_pulse")


func _pulse(msg: Dictionary):
	if msg.half_beat % 2 == 1:
		return

	var _beats_per_second: float = msg.bps

	_tween.interpolate_property(
		self, 
		"scale", 
		_start_scale, 
		_end_scale, 
		_beats_per_second / 32, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		self,
		"scale",
		_end_scale,
		_start_scale,
		_beats_per_second / 4,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		_beats_per_second / 32
	)
	_tween.start()
