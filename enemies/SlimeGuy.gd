extends "res://enemies/BaseEnemy.gd"

func _ready():
	speed = (rand_range(90, 200) * 0.25) # 0.25 speed
	anims_player.playback_speed = speed / base_speed
