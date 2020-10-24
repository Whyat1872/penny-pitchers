extends "res://enemies/BaseEnemy.gd"

func _ready():
		speed = (rand_range(90, 200) * 0.75) # 0.75 speed

func death():
	for i in range(0, max_health - 1): # -1 b/c max_health = 2
		var dropped_loot = coin_drop.instance()
		dropped_loot.position = get_global_position()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
		i += 1
