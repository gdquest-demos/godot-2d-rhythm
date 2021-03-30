extends PathFollow2D

signal movement_finished

onready var _roller := $Roller
onready var _tween := $Tween


func start_movement(delay: float, duration: float) -> void:
	
	yield(get_tree().create_timer(delay), "timeout")
	
	_roller.activate()
	
	_tween.interpolate_property(self, "unit_offset", 
		0, 1,
		duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	emit_signal("movement_finished")
