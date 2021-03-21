extends Position2D


const FRAME_PERFECT = 3
const FRAME_GREAT = 2
const FRAME_OK = 1

onready var _sprite := $Sprite
onready var _particles := $Particles2D


func _ready() -> void:
	set_as_toplevel(true)


func setup(global_pos: Vector2, score : int) -> void:
	global_position = global_pos
	if score >= 10:
		_sprite.frame = FRAME_PERFECT
		_particles.emitting = true
	elif score >= 5:
		_sprite.frame = FRAME_GREAT
	elif score >= 3:
		_sprite.frame = FRAME_OK
