extends Sprite

onready var tween := $Tween


func _ready():
	Events.connect("beat_incremented", self, "_pulse")


func _pulse(msg: Dictionary):
	var _beats_per_second = msg.bps

	tween.interpolate_property(
		self,
		"scale",
		Vector2.ONE,
		Vector2.ONE * 2,
		_beats_per_second / 32,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.interpolate_property(
		self,
		"scale",
		Vector2.ONE * 2,
		Vector2.ONE,
		_beats_per_second / 4,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		_beats_per_second / 32
	)
	tween.start()
