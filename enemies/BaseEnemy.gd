extends Area2D

signal on_death

onready var anims_player = $AnimationsPlayer
onready var fx_player = $EffectsPlayer

onready var interact_audio_player = $InteractAudio2D

onready var enemy_headstack = $EnemyHeadstack

export var kill_speed = 200

var player_ref 
var coin_drop = preload("res://player/projectiles/CopperProjectile.tscn")

export var speed = 100
var base_speed = 100
var velocity = Vector2()

export var max_health = 1
export var loot_count = 1
var current_health
var invincible = false

func _ready():
	connect("on_death", get_tree().get_root().get_node("World/HUD"), "update_kill_count")
	connect("on_death", get_tree().get_root().get_node("World/EnemySpawnArea"), "enemy_killed")
	current_health = max_health
	speed = rand_range(90, 200)
	player_ref = get_tree().get_root().get_node("World/YSort/Player")
	anims_player.play("moving")
	fx_player.play("okay")

func _process(delta):
	velocity = global_position.direction_to(player_ref.global_position)
	
	if velocity.x < 0:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)

	if enemy_headstack.coin_count > 1:
		global_position += velocity * (speed / (enemy_headstack.coin_count * 0.5)) * delta
	else:
		global_position += velocity * speed * delta

func hurt():
	interact_audio_player.play_audio("hurt")
	if self.is_in_group("armored"):
		var anim_position = anims_player.get_current_animation_position()
		anims_player.play("moving_no_armor")
		anims_player.seek(anim_position, true)
	for i in range(0, 2):
		var dropped_loot = coin_drop.instance()
		dropped_loot.position = get_global_position() + drop_offset()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
	$EnemyHeadstack.update_coin_count($EnemyHeadstack.coin_count - 1)

func death():
	$CollisionShape2D.set_deferred("disabled", true)
	self.visible = false
	for i in range(0, 2):
		var dropped_loot = coin_drop.instance()
		dropped_loot.position = get_global_position() + drop_offset()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
	emit_signal("on_death")

func drop_offset():
	var new_gen = RandomNumberGenerator.new()
	new_gen.randomize()
	var rand_angle = new_gen.randf_range(0, 359) # get random angle in radians
	var rand_radius = new_gen.randi_range(0, $CollisionShape2D.shape.radius)
	var coordinates = Vector2(cos(rand_angle), sin(rand_angle)) # find x and y vertices
	var spawn_pos = coordinates * rand_radius
	
	return spawn_pos

func add_coin(value):
	interact_audio_player.play_audio("pickup")
	current_health += value
	enemy_headstack.update_coin_count(value)
	enemy_headstack.coin_count = current_health

func temp_disable():
	set_process(false)
	yield(get_tree().create_timer(fx_player.current_animation_length + 0.5), "timeout")
	if player_ref.is_alive:
		set_process(true)

func _on_body_entered(body):
#	print(body.name)
	if body.is_in_group("player"):
		if body.can_interact:
			body.player_hit("enemy")
			temp_disable()
	elif body.is_in_group("projectile") and body.can_kill == true and !invincible:
		if body.linear_velocity.length() >= kill_speed:
			current_health -= body.value
			body.can_kill = false
			body.queue_free()
			if current_health <= 0:
				death()
				interact_audio_player.play_audio("death")
				yield(interact_audio_player, "finished")
				queue_free()
			else:
				invincible = true
				hurt()
				fx_player.play("hurt")
				set_process(false)
				yield(get_tree().create_timer(fx_player.current_animation_length),"timeout")
				set_process(true)
				invincible = false
				fx_player.play("okay")
		else:
			if !$EnemyHeadstack.coin_count >= 10:
				add_coin(body.value)
				body.queue_free()
				temp_disable()
