extends Line2D

export var growth_speed := 0.01
export var expand_width := 48.0
export var expand_time := 1.0

var _path_points := []

onready var _growth_timer := $GrowthTimer
onready var _tween := $Tween


func setup(curve_points: PoolVector2Array) -> void:
	_path_points = curve_points
	
	clear_points()


func start() -> void:
	_growth_timer.start(growth_speed)
	
	_tween.interpolate_property(self, "width", 0, 
		expand_width, expand_time, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)
	_tween.start()


func _on_GrowthTimer_timeout() -> void:
	if not _path_points:
		_growth_timer.stop()
		return
	
	add_point(_path_points.pop_front())
