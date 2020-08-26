extends Label

var total_score := 0


func _ready() -> void:
	Events.connect("scored", self, "_add_score")


func _add_score(_msg: Dictionary) -> void:
	if _msg.has("score"):
		total_score += _msg["score"]
		text = str(total_score)
