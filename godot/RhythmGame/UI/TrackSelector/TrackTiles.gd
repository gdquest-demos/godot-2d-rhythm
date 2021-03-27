extends Node2D

export var separation := 450
export (Array, Resource) var tracks: Array
export var track_tile_scene: PackedScene

var _selected_track_tile: TrackTile
var _track_tiles := []
var _bound := {"left": 0, "right": 0}

onready var _align_timer := $AlignTimer
onready var _tween := $Tween


func _ready() -> void:
	_generate_tiles()
	_update_tile_visuals()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		_align_timer.start()
		yield(_align_timer, "timeout")
		_snap_to_track(_selected_track_tile)


func _process(_delta: float) -> void:
	if _tween.is_active():
		_update_tile_visuals()


func _snap_to_track(track_tile: TrackTile) -> void:
	var relative_position = track_tile.global_position.x - get_parent().global_position.x

	_tween.interpolate_property(
		self,
		"position",
		position,
		position + Vector2(-relative_position, 0),
		0.5,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	_tween.start()


func scroll(amount: Vector2) -> void:
	_tween.stop_all()
	position.x = clamp(position.x + amount.x, _bound.right, _bound.left)
	_update_tile_visuals()


func _generate_tiles() -> void:
	var separation_current := 0.0

	for i in tracks.size():
		var track_data: TrackData = tracks[i]
		var track_tile: TrackTile = track_tile_scene.instance()

		track_tile.track_data = track_data
		_track_tiles.append(track_tile)

		track_tile.position = Vector2(separation_current, 0)
		separation_current += separation
		add_child(track_tile)

	_bound.right = -(separation * (_track_tiles.size() - 1))


func _update_tile_visuals() -> void:
	var distance_scale: float
	var distance_fade: float
	var expanded_view_bounds := get_viewport_rect().grow(200.0)
	for track_tile in _track_tiles:
		if not expanded_view_bounds.has_point(track_tile.global_position):
			continue

		var distance_normalized = range_lerp(
			abs(track_tile.global_position.x - get_parent().global_position.x),
			0,
			get_parent().global_position.x,
			0,
			1
		)

		distance_scale = 1.0 - distance_normalized
		track_tile.scale = Vector2.ONE * distance_scale

		distance_fade = distance_normalized
		track_tile.modulate.a = (1 - pow(distance_fade, 3))


func _on_track_selected(track_tile: TrackTile) -> void:
	_selected_track_tile = track_tile


func _on_DragDetector_dragged(amount: Vector2) -> void:
	scroll(amount)
