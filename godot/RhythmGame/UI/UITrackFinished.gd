extends PanelContainer


onready var animation_player := $AnimationPlayer


func _ready() -> void:
	Events.connect("track_finished", self, "_fade_in")


func _fade_in(_msg : Dictionary) -> void:
	animation_player.play("show")


func _on_ButtonTrackSelect_pressed() -> void:
	get_tree().reload_current_scene()
