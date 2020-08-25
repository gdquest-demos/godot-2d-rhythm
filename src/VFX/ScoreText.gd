extends Position2D


func _ready():
	set_as_toplevel(true)


func set_score(_amount : int):
	
	$Position2D/RichTextLabel.bbcode_text = "[center][wave amp=50 freq=10]\n" + str(_amount) + "[/wave]"
