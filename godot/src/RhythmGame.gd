extends Node2D

var score_text_scene := preload("res://src/VFX/ScoreText.tscn")


func _ready() -> void:
	Events.connect("scored", self, "_create_score_fx")
	Events.connect("track_finished", self, "_game_over")

	$AnimationPlayer.play("begin_game")


func _create_score_fx(_msg: Dictionary) -> void:
	if _msg.has("score"):
		var new_score_text = score_text_scene.instance()
		new_score_text.global_position = get_global_mouse_position()
		add_child(new_score_text)
		new_score_text.set_score(_msg["score"])


func _game_over(_msg: Dictionary) -> void:
	$AnimationPlayer.play("game_over")
