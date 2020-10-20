extends Control


func _ready() -> void:
	Events.connect("track_selected", self, "_fade_in")


func _fade_in(_msg: Dictionary) -> void:
	visible = true
