extends Area2D

export var info: Resource


func _ready():
	$Sprite.texture = info.icon


func get_data() -> Dictionary:
	return info.get_data()
