extends Label

var total_score := 0


func _ready() -> void:
	Events.connect("scored", self, "_add_score")


func _add_score(msg: Dictionary) -> void:
	total_score += msg.score
	text = str(total_score)
