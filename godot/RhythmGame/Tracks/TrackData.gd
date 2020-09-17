class_name TrackData
extends Resource

export var label := "Track Name"
export (String, FILE, "*.ogg") var stream
export var bpm := 1
export var icon: Texture
export var artist := "Artist"


func get_data() -> Dictionary:
	return {"name": label, "stream": stream, "bpm": bpm, "icon": icon, "artist": artist}
