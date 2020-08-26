extends Position2D

onready var rich_label := $Position2D/RichTextLabel


func _ready() -> void:
	set_as_toplevel(true)


func set_score(_amount: int) -> void:
	rich_label.bbcode_text = ("[center][wave amp=50 freq=10]\n %s [/wave]" % _amount)
