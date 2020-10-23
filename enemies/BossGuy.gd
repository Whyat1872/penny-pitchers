extends "res://enemies/BaseEnemy.gd"

func _ready():
	speed /= 2
	anims_player.playback_speed /= 2 
