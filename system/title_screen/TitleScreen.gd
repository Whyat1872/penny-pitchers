extends Node

var main_game_scene = load("res://World.tscn")
var instructions_scene = load("res://system/instructions_screen/InstructionsScreen.tscn")
var wardrobe_scene = load("res://system/skin_select/SkinSelectScreen.tscn")
var credits_scene = load("res://system/title_screen/CreditsScreen.tscn")

func _on_StartButton_button_up():
	get_tree().change_scene_to(main_game_scene)

func _on_InstructionsButton_button_up():
	var new_instructions = instructions_scene.instance()
	add_child(new_instructions)
	new_instructions.rect_position = Vector2(352, 160)

func _on_WardrobeButton_button_up():
	var new_wardrobe = wardrobe_scene.instance()
	add_child(new_wardrobe)
	new_wardrobe.rect_position = Vector2(352, 160)

func _on_CreditsButton_button_up():
	var new_credits = credits_scene.instance()
	add_child(new_credits)
	new_credits.rect_position = Vector2(352, 160)

func _on_QuitButton_button_up():
	get_tree().quit()
