extends Node

const ORANGE := Color("#e36956")
const GREEN := Color("#3ca370")
const BLUE := Color("#4da6ff")
const PINK := Color("#ff6b97")
const GRAY := Color("#7e7e8f")
const WHITE := Color("#ffffeb")

func get_random_color() -> Color:
	
	var _colors = []
	
	_colors.append(ORANGE)
	_colors.append(GREEN)
	_colors.append(BLUE)
	_colors.append(PINK)
	_colors.append(GRAY)
	
	_colors.shuffle()
	
	return _colors[0]
	
	
