extends Node2D

export var sprite_fx: PackedScene


func _ready() -> void:
	Events.connect("scored", self, "_create_score_fx")


func _create_score_fx(msg: Dictionary) -> void:
	var new_sprite_fx := sprite_fx.instance()

	add_child(new_sprite_fx)
	new_sprite_fx.setup(msg.position, msg.score)
