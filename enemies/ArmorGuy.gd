extends "res://enemies/BaseEnemy.gd"

func _ready():
	speed = (rand_range(90, 200) * 0.75) # 0.75 speed
