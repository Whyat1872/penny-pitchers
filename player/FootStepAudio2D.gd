extends AudioStreamPlayer2D

var file_name = ""
var file_type = ""
var current_track = 0

func play_audio():
	match current_track:
		0:
			file_name = "footstep3"
			file_type = "wav"
			current_track += 1
		1:
			file_name = "footstep4"
			file_type = "wav"
			current_track -= 1
		_:
			file_name = "footstep3"
			file_type = "wav"
	var string_path = "res://sound/%s.%s" % [file_name, file_type]
	self.stream = load(string_path)
	self.play()
