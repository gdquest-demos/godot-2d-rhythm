extends Position2D


onready var sprite := $Sprite


func _ready() -> void:
	set_as_toplevel(true)


func set_score(score : int) -> void:
	if score >= 10:
		sprite.frame = 3
		$Particles2D.emitting = true
	elif score >= 5:
		sprite.frame = 2
	elif score >= 3:
		sprite.frame = 1

