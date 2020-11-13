extends ColorRect

func _ready():
	var current_skin = PlayerGlobal.player_skin
	$MarginContainer/VBoxContainer/CurrentSkin/AnimationPlayer.play("active")
	for child in $MarginContainer/VBoxContainer/GridContainer.get_children():
		child.connect("skin_selected", self, "update_window")
		if child.skin_index == current_skin:
			child.update_selected(true)
	update_window(current_skin)

func update_window(new_skin_index):
	$MarginContainer/VBoxContainer/CurrentSkin.skin_index = new_skin_index
	PlayerGlobal.player_skin = new_skin_index
	for child in $MarginContainer/VBoxContainer/GridContainer.get_children():
		child.update_selected(false)
		if child.skin_index == $MarginContainer/VBoxContainer/CurrentSkin.skin_index:
			child.update_selected(true)

func _on_ExitButton_button_up():
	queue_free()
