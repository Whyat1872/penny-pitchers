extends Path2D

onready var badguy = preload("res://enemies/BadGuy.tscn")
onready var bossguy = preload("res://enemies/BossGuy.tscn")
onready var armorguy = preload("res://enemies/ArmorGuy.tscn")
onready var ghostguy = preload("res://enemies/GhostGuy.tscn")
onready var slimeguy = preload("res://enemies/SlimeGuy.tscn")

onready var spawn_timer = $SpawnTimer

export var badguy_interval = 1
export var bossguy_interval = 8
export var armorguy_interval = 10
export var ghostguy_interval = 15
export var slimeguy_interval = 17

var spawned_enemies = 0
var spawn_intervals

func _ready():
	spawn_intervals = [badguy_interval, bossguy_interval, armorguy_interval, ghostguy_interval, slimeguy_interval]

func _on_player_death():
	spawn_timer.stop()
	print("lol get rekt")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://system/title_screen/TitleScreen.tscn")

func _on_SpawnTimer_timeout():
	spawned_enemies += 1
	var mob
	for i in spawn_intervals:
		match spawned_enemies % i:
			0:
				match i: # top: least frequent, bottom: most frequent
					bossguy_interval:
						mob = bossguy.instance()
#						print("spawned bossguy")
					ghostguy_interval:
						mob = ghostguy.instance()
#						print("spawned ghostguy")
					slimeguy_interval:
						mob = slimeguy.instance()
#						print("spawned slimeguy")
					armorguy_interval:
						mob = armorguy.instance()
#						print("spawned armorguy")
					badguy_interval:
						mob = badguy.instance()
#						print("spawned badguy")
	if mob != null:
		$EnemySpawnSpot.offset = randi()
		get_tree().get_root().get_node("World/YSort").add_child(mob)
#		var direction = $EnemySpawnSpot.rotation + PI / 2
		mob.position = $EnemySpawnSpot.position
#		direction += rand_range(-PI / 4, PI / 4)
	
