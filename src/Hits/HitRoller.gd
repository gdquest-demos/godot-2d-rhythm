extends Path2D

onready var path_follow = $PathFollow2D
onready var start_beat = $Beat
onready var animation_player = $AnimationPlayer

export var beat_number := 0
export var show_delay := 0
export var lifetime_beats = 2.0

var bps = 60.0/124

var fill_color = Colors.ORANGE
var player_tracking = false
var moving = false
var score = 1

var segments = 10
var data = { }

func _ready():
	modulate.a = 0.0
	animation_player.play("show")
	$Line2D.all_points = curve.get_baked_points()
	
	data = {
		"show_delay" : show_delay,
		"type" : "roller",
		"position" : global_position,
		"curve" : $Line2D.all_points,
		"beat_number" : beat_number,
		"lifetime_beats" : lifetime_beats
		}
	
	$Beat.beat_number = beat_number
	$Label.rect_position = $Line2D.all_points[$Line2D.all_points.size() - 1] - Vector2(50, 50)
	$Label.text = str(beat_number + 1)
	$Label.visible = true
	
	yield(start_beat, "beat_aligned")
	moving = true
	
	$Timer.start(bps *  lifetime_beats / segments)

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
	return 1.0/bps/lifetime_beats

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
		Events.emit_signal("scored", score)
	
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
