extends Area2D

signal on_death

onready var anims_player = $AnimationsPlayer
onready var fx_player = $EffectsPlayer

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
	current_health = max_health
	speed = rand_range(90, 200)
	player_ref = get_tree().get_root().get_node("World/YSort/Player")
	anims_player.play("moving")
	fx_player.play("okay")
	$DebugStatsLabel.update_label(current_health, max_health, loot_count)

func _process(delta):
	velocity = global_position.direction_to(player_ref.global_position)
	
	if velocity.x < 0:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)

	global_position += velocity * speed * delta

func hurt():
	if self.is_in_group("armored"):
		var anim_position = anims_player.get_current_animation_position()
		anims_player.play("moving_no_armor")
		anims_player.seek(anim_position, true)
	var dropped_loot = coin_drop.instance()
	dropped_loot.position = get_global_position() + drop_offset()
	get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
	$EnemyHeadstack.update_coin_count($EnemyHeadstack.coin_count - 1)
	$DebugStatsLabel.update_label(current_health, max_health, loot_count)

func death():
	for i in range(0, loot_count):
		var dropped_loot = coin_drop.instance()
		dropped_loot.position = get_global_position() + drop_offset()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
		i += 1
	emit_signal("on_death")

func drop_offset():
	var new_gen = RandomNumberGenerator.new()
	new_gen.randomize()
	var rand_angle = new_gen.randf_range(0, 359) # get random angle in radians
	var rand_radius = new_gen.randi_range(0, $CollisionShape2D.shape.radius)
	var coordinates = Vector2(cos(rand_angle), sin(rand_angle)) # find x and y vertices
	var spawn_pos = coordinates * rand_radius
	
	return spawn_pos

func _on_body_entered(body):
#	print(body.name)
	if body.is_in_group("player"):
		if body.can_interact:
			body.player_hit()
	elif body.is_in_group("projectile") and body.can_kill == true and !invincible:
		if body.linear_velocity.length() >= kill_speed:
			current_health -= body.value
			body.can_kill = false
			body.queue_free()
			if current_health <= 0:
				death()
				queue_free()
			else:
				invincible = true
				hurt()
				fx_player.play("hurt")
				yield(get_tree().create_timer(fx_player.current_animation_length),"timeout")
				invincible = false
				fx_player.play("okay")
