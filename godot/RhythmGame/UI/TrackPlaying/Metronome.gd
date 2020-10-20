extends Sprite

var start := Vector2.ONE
var end := Vector2.ONE * 1.5

onready var tween := $Tween


func _ready():
	Events.connect("beat_incremented", self, "_pulse")


func _pulse(msg: Dictionary):
	if msg.beat_number % 2 == 1:
		return

	var _beats_per_second: float = msg.bps

	tween.interpolate_property(
		self, 
		"scale", 
		start, 
		end, 
		_beats_per_second / 32, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		self,
		"scale",
		end,
		start,
		_beats_per_second / 4,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		_beats_per_second / 32
	)
	tween.start()
