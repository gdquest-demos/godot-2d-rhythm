extends Path2D

onready var path_follow = $PathFollow2D
onready var start_beat = $Beat
onready var animation_player = $AnimationPlayer

export var beat_number := 0 setget set_beat_number
export var show_delay := 0
export var beat_duration = 2.0

var bps = 60.0/124

var fill_color = Colors.ORANGE
var player_tracking = false
var moving = false
var score = 1

var segments = 10

func _ready():
	modulate.a = 0.0
	animation_player.play("show")
	
	yield(start_beat, "beat_aligned")
	moving = true
	$Timer.start(bps *  beat_duration / segments)


func initialize(_dict : Dictionary):
	
	if _dict.has("beat_number"):
		self.beat_number = _dict["beat_number"]
	
	if _dict.has("beat_duration"):
		beat_duration = _dict["beat_duration"]
	
	if _dict.has("curve"):
		curve = _dict["curve"]
	
	$Line2D.all_points = curve.get_baked_points()
	
	$FirstBeat.rect_position = $Line2D.all_points[0] - Vector2(50, 50)
	$SecondBeat.rect_position = $Line2D.all_points[$Line2D.all_points.size() - 1] - Vector2(50, 50)
	$SecondBeat.text = str(beat_number + 1)
	$SecondBeat.visible = true
	
	if _dict.has("position"):
		position = _dict["position"]
	
	$Beat.position = curve.get_point_position(0)
	
	if _dict.has("color"):
		set_color(_dict["color"])


func set_beat_number(_no : int):
	$Beat.set_beat_number(_no)
	$FirstBeat.text = str(_no)
	beat_number = _no
	$SecondBeat.text = str(beat_number)

func set_color(color):
	fill_color = color
	find_node("Roller").fill_color = color
	$Beat.set_color(color)
	$Line2D.default_color = color

func _draw():
	
	draw_circle(curve.get_point_position(0), 64.0, fill_color)
	draw_arc(curve.get_point_position(0), 64.0, 0.0, 2*PI, 100, Colors.WHITE, 6.0, true)
	
	draw_circle(curve.get_point_position(curve.get_point_count() - 1), 64.0, fill_color)
	draw_arc(curve.get_point_position(curve.get_point_count() - 1), 64.0, 0.0, 2*PI, 100, Colors.WHITE, 6.0, true)


func get_speed():
	return 1.0/bps/beat_duration

func set_text(_one, _two):
	start_beat.set_text(_one)
	$Label.text = _two

func _process(delta):
	
	if not moving:
		return
	
	path_follow.unit_offset += delta*get_speed()
	
	update()
	
	
	if path_follow.unit_offset >= 1:
		_complete()


func _complete():
	moving = false
	
	if player_tracking:
		Events.emit_signal("scored", {"score" : min(score, 10)})
	
	animation_player.play("destroy")


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("touch"):
		player_tracking = true


func _on_Area2D_mouse_exited():
	player_tracking = false


func _on_Area2D_mouse_entered():
	if Input.is_action_pressed("touch"):
		player_tracking = true


func _on_Timer_timeout():
	if player_tracking:
		score += 1
	$Timer.start()
