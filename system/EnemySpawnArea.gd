extends Path2D

signal good_to_go

onready var badguy = preload("res://enemies/BadGuy.tscn")
onready var bossguy = preload("res://enemies/BossGuy.tscn")
onready var armorguy = preload("res://enemies/ArmorGuy.tscn")
onready var ghostguy = preload("res://enemies/GhostGuy.tscn")
onready var slimeguy = preload("res://enemies/SlimeGuy.tscn")

export var badguy_interval = 1
export var bossguy_interval = 4
export var armorguy_interval = 6
export var ghostguy_interval = 12
export var slimeguy_interval = 10

var spawned_enemies = 0
var spawn_intervals

var current_wave = 0
var current_alive_enemies = 0
var current_max_enemies = 0

var shop_interval = 2 # default is 5

func _ready():
	spawn_intervals = [badguy_interval, bossguy_interval, armorguy_interval, ghostguy_interval, slimeguy_interval]
	yield(get_tree().create_timer(2), "timeout")
	check_wave()

func check_wave():
	if current_alive_enemies <= 0:
		if current_wave % shop_interval == 0 and current_wave != 0:
			print("spawn shop")
			var new_shop = load("res://shop/UpgradeShop.tscn").instance()
			call_deferred("add_shop", new_shop)
			yield(get_tree().create_timer(0.1), "timeout")
			yield(get_parent().get_node(new_shop.name), "shop_closed")
		current_wave += 1
		current_max_enemies = int(clamp(current_wave * 0.5, 1, 10))
		print("wave:%s, enemies:%s" % [current_wave, current_max_enemies])
		spawn_enemies(current_wave, current_max_enemies)
	print("enemies left: %s" % current_alive_enemies)

func add_shop(new_shop):
	get_parent().add_child(new_shop, true)
	new_shop.name = "UpgradeShop"

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
		if i == enemy_amount - 1:
			new_mob = make_mob()
		if new_mob != null:
			$EnemySpawnSpot.offset = randi()
			get_tree().get_root().get_node("World/YSort").call_deferred("add_child", new_mob)
			new_mob.position = $EnemySpawnSpot.position
	current_alive_enemies = enemy_amount

func make_mob():
	if current_wave % spawn_intervals[1] == 0:
		return bossguy.instance()
	elif current_wave % spawn_intervals[3] == 0:
		return ghostguy.instance()
	elif current_wave % spawn_intervals[4] == 0:
		return slimeguy.instance()
	elif current_wave % spawn_intervals[2] == 0:
		return ghostguy.instance()
	else:
		return badguy.instance()
