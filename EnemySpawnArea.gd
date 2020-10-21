extends Path2D

onready var enemy = preload("res://enemies/BlueGuy.tscn")
onready var spawn_timer = $SpawnTimer

func _on_SpawnTimer_timeout():
	$EnemySpawnSpot.offset = randi()
	var mob = enemy.instance()
	get_tree().get_root().get_node("World/YSort").add_child(mob)
	var direction = $EnemySpawnSpot.rotation + PI / 2
	mob.position = $EnemySpawnSpot.position
	direction += rand_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction)
	# warning-ignore:return_value_discarded
#	$HUD.connect("start_game", mob, "_on_start_game")
