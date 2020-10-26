extends Node

var main_game_scene = load("res://World.tscn")
var instructions_scene = load("res://system/instructions_screen/InstructionsScreen.tscn")

func _on_StartButton_button_up():
	get_tree().change_scene_to(main_game_scene)

func _on_InstructionsButton_button_up():
	var new_instructions = instructions_scene.instance()
	add_child(new_instructions)
	new_instructions.rect_position = Vector2(352, 160)

func _on_QuitButton_button_up():
	get_tree().quit()
