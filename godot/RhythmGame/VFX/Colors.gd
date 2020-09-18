class_name Colors

const LIST := [
	Color("#e36956"), #orange
	Color("#3ca370"), #green
	Color("#4da6ff"), #blue
	Color("#ff6b97"), #pink
	Color("#e43b44"), #red
	Color("#7e7e8f") #grey
]

const WHITE := Color("#ffffeb")
const BLACK := Color("#272736")


static func get_random_color() -> Color:
	return LIST[int(rand_range(0, LIST.size()-1))]
