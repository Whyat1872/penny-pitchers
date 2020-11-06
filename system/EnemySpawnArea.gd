extends Path2D

onready var badguy = preload("res://enemies/BadGuy.tscn")
onready var bossguy = preload("res://enemies/BossGuy.tscn")
onready var armorguy = preload("res://enemies/ArmorGuy.tscn")
onready var ghostguy = preload("res://enemies/GhostGuy.tscn")
onready var slimeguy = preload("res://enemies/SlimeGuy.tscn")

export var badguy_interval = 1
export var bossguy_interval = 8
export var armorguy_interval = 10
export var ghostguy_interval = 15
export var slimeguy_interval = 17

var spawned_enemies = 0
var spawn_intervals

var current_wave = 0
var current_alive_enemies = 0
var current_max_enemies = 0

func _ready():
	spawn_intervals = [badguy_interval, bossguy_interval, armorguy_interval, ghostguy_interval, slimeguy_interval]
	check_wave()

func check_wave():
	if current_alive_enemies <= 0:
		current_wave += 1
		current_max_enemies += 1
		print("wave:%s, enemies:%s" % [current_wave, current_max_enemies])
		spawn_enemies(current_wave, current_max_enemies)
	print("enemies left: %s" % current_alive_enemies)

func _on_player_death():
	print("lol get rekt")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://system/title_screen/TitleScreen.tscn")

func enemy_killed():
	current_alive_enemies -= 1
	check_wave()

func spawn_enemies(enemy_wave, enemy_amount):
	var new_mob
	for i in range(0, enemy_amount):
		new_mob = badguy.instance()
		if new_mob != null:
			$EnemySpawnSpot.offset = randi()
			get_tree().get_root().get_node("World").call_deferred("add_child", new_mob)
			new_mob.position = $EnemySpawnSpot.position
	current_alive_enemies = enemy_amount
