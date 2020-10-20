extends Node2D

export var scale_radius := 1000
export var separation := 450
export (Array, Resource) var tracks: Array
export var track_tile_scene: PackedScene

var _selected_track_tile = null
var _track_tiles := []
var _bound := {"left": 0, "right": 0}

onready var align_timer := $AlignTimer
onready var tween := $Tween


func _ready() -> void:
	for track in tracks:
		var track_tile = track_tile_scene.instance()
		track_tile.info = track
		_track_tiles.append(track_tile)
		add_child(track_tile)

	var current_separation = 0.0

	for track in _track_tiles:
		track.position = Vector2(current_separation, 0)
		current_separation += separation

	_update_tile_visuals()

	_bound.right = -(separation * (_track_tiles.size() - 1))


func _input(event) -> void:
	if event.is_action_released("touch"):
		align_timer.start()
		yield(align_timer, "timeout")
		_snap_to_track(_selected_track_tile)


func _process(_delta) -> void:
	if tween.is_active():
		_update_tile_visuals()


func _snap_to_track(track_tile) -> void:
	var relative_position = track_tile.global_position.x - get_parent().global_position.x

	tween.interpolate_property(
		self,
		"position",
		position,
		position + Vector2(-relative_position, 0),
		0.5,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	tween.start()


func scroll(amount: Vector2) -> void:
	tween.stop_all()
	position.x = clamp(position.x + amount.x, _bound.right, _bound.left)
	_update_tile_visuals()
	align_timer.start()


func _update_tile_visuals() -> void:
	var _scale
	var _fade
	for tile in _track_tiles:
		var distance_normalized = range_lerp(
			abs(tile.global_position.x - get_parent().global_position.x),
			0,
			get_parent().global_position.x,
			0,
			1
		)

		_scale = 1.0 - distance_normalized
		tile.scale = Vector2.ONE * _scale

		_fade = distance_normalized
		tile.modulate.a = (1 - pow(_fade, 3))


func _on_track_selected(track_tile) -> void:
	_selected_track_tile = track_tile
