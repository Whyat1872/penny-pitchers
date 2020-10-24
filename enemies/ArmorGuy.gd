extends "res://enemies/BaseEnemy.gd"

func _ready():
	speed = (rand_range(90, 200) * 0.75) # 0.75 speed

func _on_body_entered(body):
#	print(body.name)
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	elif body.is_in_group("projectile") and body.can_kill == true and !invincible:
		if body.linear_velocity.length() >= kill_speed:
			current_health -= 1
			body.can_kill = false
			body.queue_free()
			if current_health <= 0:
				death()
				queue_free()
			else:
				invincible = true
				anims_player.play("moving_no_armor")
				fx_player.play("hurt")
				yield(get_tree().create_timer(fx_player.current_animation_length),"timeout")
				invincible = false
				fx_player.play("okay")
