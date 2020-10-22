extends Path2D

onready var enemy = preload("res://enemies/BadGuy.tscn")
onready var boss = preload("res://enemies/BossGuy.tscn")
onready var spawn_timer = $SpawnTimer

export var boss_interval = 10

var spawned_enemies = 0

func _on_SpawnTimer_timeout():
	spawned_enemies += 1
	var mob
	match spawned_enemies % boss_interval:
		0:
			mob = boss.instance()
		_:
			mob = enemy.instance()
	$EnemySpawnSpot.offset = randi()
	get_tree().get_root().get_node("World/YSort").add_child(mob)
	var direction = $EnemySpawnSpot.rotation + PI / 2
	mob.position = $EnemySpawnSpot.position
	direction += rand_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction)
	# warning-ignore:return_value_discarded
#	$HUD.connect("start_game", mob, "_on_start_game")
