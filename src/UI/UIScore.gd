extends Label


var total_score := 0


func _ready():
	Events.connect("scored", self, "_add_score")


func _add_score(_msg : Dictionary):
	if _msg.has("score"):
		total_score += _msg["score"]
		text = str(total_score)
