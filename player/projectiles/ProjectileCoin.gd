extends "res://player/projectiles/BaseProjectile.gd"

var value = 1

func _on_body_entered(body):
#	print(body)
	if body.is_in_group("player"):
		body.add_coin(value)
		queue_free()
