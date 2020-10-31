extends Label

var _total_score := 0


func _ready() -> void:
	Events.connect("scored", self, "_add_score")


func _add_score(msg: Dictionary) -> void:
	_total_score += msg.score
	text = str(_total_score)
