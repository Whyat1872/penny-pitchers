extends "res://interactables/money/BaseCollectable.gd"

export var value = 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_coin(value)
		queue_free()
