extends AudioStreamPlayer2D

var file_name = ""
var file_type = ""
var current_track = 0

func play_audio(interaction):
	match interaction:
		"pickup":
			file_name = "pickup"
			file_type = "wav"
		"shoot":
			file_name = "shoot"
			file_type = "wav"
		"low_ammo":
			file_name = "shoot2"
			file_type = "wav"
	var string_path = "res://sound/%s.%s" % [file_name, file_type]
	self.stream = load(string_path)
	self.play()
