extends "res://player/projectiles/BaseProjectile.gd"

func _on_body_entered(body):
#	print(body)
	if body.is_in_group("player"):
		if body.can_interact:
			body.add_coin(value)
			queue_free()
