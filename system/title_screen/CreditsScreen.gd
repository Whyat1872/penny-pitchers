extends ColorRect

func _on_ExitButton_button_up():
	queue_free()

func _on_GameLabel_button_up():
	OS.shell_open("https://whyat1872.itch.io/")

func _on_MusicLabel_button_up():
	OS.shell_open("https://opengameart.org/content/kb-battle-in-the-sky")
