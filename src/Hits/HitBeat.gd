extends Node2D

signal beat_aligned

export var beat_number := 0 setget set_beat_number
export var show_delay := 0

onready var animation_player := $AnimationPlayer
onready var touch_area := $Area2D

var beat_aligned := false
var bps := 60.0 / 124.0
var beat_delay := 4.0  #beats before perfect

var radius_start := 124.0
var radius := radius_start
var radius_perfect := 64.0

var offset_perfect := 3
var offset_good := 6
var offset_ok := 18
var offset_miss := 19

var fill_color := Colors.ORANGE

var score := 0


func _ready() -> void:
	animation_player.play("show")


func initialize(_dict: Dictionary) -> void:
	if _dict.has("beat_number"):
		self.beat_number = _dict["beat_number"]
	
	if _dict.has("bps"):
		self.bps = _dict["bps"]
	
	if _dict.has("global_position"):
		global_position = _dict["global_position"]

	if _dict.has("color"):
		set_color(_dict["color"])


func set_beat_number(_no: int) -> void:
	beat_number = _no
	$Label.text = str(beat_number)


func set_color(color: Color) -> void:
	fill_color = color


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius_perfect, fill_color)
	draw_arc(Vector2.ZERO, radius_perfect, 0.0, 2 * PI, 100, Colors.WHITE, 6.0, true)
	draw_arc(Vector2.ZERO, radius, 0.0, 2 * PI, 100, fill_color, 6.0, true)


func get_speed() -> float:
	return 1.0 / bps / beat_delay


func _process(delta: float) -> void:
	radius -= delta * (radius_start - radius_perfect) * get_speed()
	update()

	if not beat_aligned and radius <= radius_perfect:
		emit_signal("beat_aligned", {})
		animation_player.play("destroy")
		beat_aligned = true


func _get_score() -> int:
	if abs(radius_perfect - radius) < offset_perfect:
		return 10
	elif abs(radius_perfect - radius) < offset_good:
		return 5
	elif abs(radius_perfect - radius) < offset_ok:
		return 3
	return 0


func _on_Area2D_input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("touch"):
		Events.emit_signal("scored", {"score": _get_score()})
		touch_area.collision_layer = 0
