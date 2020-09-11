extends Node2D


export var score_text_scene: PackedScene

onready var animation_player := $AnimationPlayer


func _ready() -> void:
	Events.connect("scored", self, "_create_score_fx")
	Events.connect("track_finished", self, "_game_over")

	animation_player.play("begin_game")


func _create_score_fx(msg: Dictionary) -> void:
	var new_score_text := score_text_scene.instance()

	new_score_text.global_position = msg.position

	add_child(new_score_text)
	new_score_text.set_score(msg.score)


func _game_over(_msg: Dictionary) -> void:
	animation_player.play("game_over")
