extends Button

signal skin_selected

export var skin_index = 0
var is_selected = false

func _ready():
	$Sprite.region_rect.position.y = skin_index * 8
	update_selected(false)

func update_anim_region(anim_index):
	var new_rect = skin_index * 8
	match anim_index:
		0:
			$Sprite.region_rect.position = Vector2(0, new_rect)
			anim_index = 1
		1:
			$Sprite.region_rect.position = Vector2(8, new_rect)
			anim_index = 0

func update_selected(new_state):
	is_selected = new_state
	match is_selected:
		true:
			$AnimationPlayer.play("active")
			$Sprite.self_modulate.a8 = 255
		false:
			$AnimationPlayer.play("inactive")
			if !disabled:
				$Sprite.self_modulate.a8 = 128

func _on_button_up():
	update_selected(true)
	emit_signal("skin_selected", skin_index)
