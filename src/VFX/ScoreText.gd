extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	pass # Replace with function body.

func set_text(_text : String):
	
	$Position2D/RichTextLabel.bbcode_text = "[center][wave amp=50 freq=10]\n" + _text + "[/wave]"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
