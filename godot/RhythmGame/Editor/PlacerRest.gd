tool
extends Node2D
class_name PlacerRest, "res://RhythmGame/Editor/placer_rest_icon.svg"

export (int, 1, 4) var duration := 2 setget set_duration

var _order_number := 1


func _enter_tree() -> void:
	_order_number = get_index() + 1
	$OrderNumber.text = str(_order_number)


func get_data() -> Dictionary:
	return {duration = duration}


func set_duration(amount : int) -> void:
	duration = amount
	$Sprite.frame = duration - 1
