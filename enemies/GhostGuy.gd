extends "res://enemies/BaseEnemy.gd"

func _ready():
		speed = (rand_range(90, 200) * 1.25) # 1.25 speed
