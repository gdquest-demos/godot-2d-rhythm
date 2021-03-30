extends Path2D

var order_number := 0 setget set_order_number

var _beat_delay := 4.0  #beats before roller start

var _radius_start := 150.0
var _radius_perfect := 70.0  #(150 - TargetCircle width) / 2.0

onready var _sprite_start := $SpriteStart
onready var _label_start := $SpriteStart/Label
onready var _sprite_end := $SpriteEnd
onready var _label_end := $SpriteEnd/Label

onready var _animation_player := $AnimationPlayer
onready var _target_circle := $TargetCircle

onready var _roller_follow := $RollerFollow
onready var _roller := $RollerFollow/Roller
onready var _growing_line := $GrowingLine2D


func _ready() -> void:
	_animation_player.play("show")


func setup(data: Dictionary) -> void:
	
	curve = data.curve
	
	var curve_points := curve.get_baked_points()
	
	_growing_line.setup(curve_points)
	_growing_line.start()

	_sprite_start.position = curve_points[0]
	_sprite_end.position = curve_points[curve_points.size() - 1]
	
	_roller.setup(data.bps, data.duration, data.color)
	
	var roller_path_delay = data.bps * _beat_delay
	var roller_path_duration = data.bps * data.duration / 2.0
	_roller_follow.start_movement(roller_path_delay, roller_path_duration)
	
	self.order_number = data.order_number
	
	global_position = data.global_position

	_sprite_start.frame = data.color
	_sprite_end.frame = data.color
	
	_target_circle.setup(_radius_start, _radius_perfect, data.bps, _beat_delay)


func set_order_number(number: int) -> void:
	order_number = number
	_label_start.text = str(number)
	_label_end.text = str(number + 1)


func destroy() -> void:
	_animation_player.play("destroy")
