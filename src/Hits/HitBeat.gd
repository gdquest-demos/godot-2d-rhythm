extends Node2D

signal beat_aligned

onready var animation_player = $AnimationPlayer
onready var touch_area = $Area2D

export var beat_number := 0 setget set_beat_number
export var show_delay := 0

var beat_aligned = false

var bps := 60.0/124.0

var beat_delay := 4.0 #beats before perfect
var beat := 0

var radius_start := 124.0
var radius := radius_start
var radius_perfect := 64.0

var offset_perfect := 3
var offset_good := 6
var offset_ok := 18
var offset_miss := 19

var score = 0

var fill_color := Colors.ORANGE


func _ready():
	animation_player.play("show")


func initialize(_dict : Dictionary):
	
	if _dict.has("beat_number"):
		self.beat_number = _dict["beat_number"]
	
	if _dict.has("global_position"):
		global_position = _dict["global_position"]
	
	if _dict.has("color"):
		set_color(_dict["color"])


func set_beat_number(_no : int):
	
	beat_number = _no
	$Label.text = str(beat_number)


func set_text(_text):
	$Label.text = _text


func set_color(color):
	fill_color = color


func _draw():
	draw_circle(Vector2.ZERO, radius_perfect, fill_color)
	draw_arc(Vector2.ZERO, radius_perfect, 0.0, 2*PI, 100, Colors.WHITE, 6.0, true)
	draw_arc(Vector2.ZERO, radius, 0.0, 2*PI, 100, fill_color, 6.0, true)


func get_speed():
	return 1.0/bps/beat_delay


func _process(delta):
	radius -= delta*(radius_start - radius_perfect)*get_speed()
	update()
	
	if abs(radius_perfect - radius) < offset_perfect:
		score = 10
	elif abs(radius_perfect - radius) < offset_good:
		score = 5
	elif abs(radius_perfect - radius) < offset_ok:
		score = 3
	
	if not beat_aligned and radius <= radius_perfect:
		emit_signal("beat_aligned", {})
		animation_player.play("destroy")
		beat_aligned = true


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("touch"):
		Events.emit_signal("scored", {"score" : score})
		touch_area.collision_layer = 0
