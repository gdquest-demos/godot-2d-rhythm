extends Node2D

export var sprite_fx: PackedScene


func _ready() -> void:
	Events.connect("scored", self, "_create_score_fx")


func _create_score_fx(msg: Dictionary) -> void:
	var new_sprite_fx := sprite_fx.instance()

	new_sprite_fx.global_position = msg.position

	add_child(new_sprite_fx)
	new_sprite_fx.set_score(msg.score)
