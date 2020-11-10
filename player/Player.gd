extends KinematicBody2D

signal player_death

export var speed = 250

onready var anim_player = $AnimsPlayer
onready var fx_player = $FXAnimPlayer
onready var head_stack = $HeadStack

onready var interact_audio_player = $InteractAudio2D

var current_coins = 1

var is_alive = true
var can_interact = true

var spritesheet_index = 3
var anim_index = 0

func _ready():
	connect("player_death", get_tree().get_root().get_node("World/EnemySpawnArea"), "_on_player_death")
	connect("player_death", get_tree().get_root().get_node("World/YSort"), "_on_player_death")
	anim_player.play("idle")
	fx_player.play("okay")

func _input(_event):
	if is_alive:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()

func update_anim_region(anim_index):
	var new_rect = spritesheet_index * 8
	match anim_index:
		0:
			$Sprite.region_rect = Rect2(Vector2(0, new_rect), Vector2(8, 8))
			anim_index = 1
		1:
			$Sprite.region_rect = Rect2(Vector2(8, new_rect), Vector2(8, 8))
			anim_index = 0

func _physics_process(delta):
	if is_alive:
		var direction = Vector2()
		if Input.is_action_pressed("ui_up"):
			direction += Vector2(0, -1)
		if Input.is_action_pressed("ui_down"):
			direction += Vector2(0, 1)
		if Input.is_action_pressed("ui_left"):
			direction += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			direction += Vector2(1, 0)

		moving_animation_handler(direction)
		if current_coins > 0:
			move_and_slide(direction * (speed / current_coins))
		else:
			move_and_slide(direction * speed)
	else:
		anim_player.play("idle")

func add_coin(value):
	if can_interact:
		if !value < 0:
			interact_audio_player.play_audio("pickup")
		current_coins += value
		head_stack.update_coin_count(value)
		head_stack.coin_count = current_coins

func player_hit(source):
	hurt(source)
	if current_coins <= 0:
		is_alive = false
		visible = false
		interact_audio_player.play_audio("death")
		yield(interact_audio_player, "finished")
		emit_signal("player_death")
	else:
		fx_player.play("hurt")
		yield(get_tree().create_timer(fx_player.current_animation_length),"timeout")
		can_interact = true
		$CollisionShape2D.set_deferred("disabled", false)
		fx_player.play("okay")

func hurt(source):
	$CollisionShape2D.set_deferred("disabled", true)
	current_coins -= 1
	head_stack.update_coin_count(current_coins)
	can_interact = false
	if source == "enemy":
		interact_audio_player.play_audio("hurt")
		var dropped_loot = $Aimer.projectiles[0].instance()
		dropped_loot.position = get_global_position() + drop_offset()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)

func drop_offset():
	var new_gen = RandomNumberGenerator.new()
	new_gen.randomize()
	var rand_angle = new_gen.randf_range(0, 359) # get random angle in radians
	var rand_radius = new_gen.randi_range(0, $CollisionShape2D.shape.radius)
	var coordinates = Vector2(cos(rand_angle), sin(rand_angle)) # find x and y vertices
	var spawn_pos = coordinates * rand_radius
	
	return spawn_pos

func moving_animation_handler(current_dir):
	if current_dir.x < 0:
		$Sprite.set_flip_h(true)
		head_stack.scale.x = -1
	elif current_dir.x > 0:
		$Sprite.set_flip_h(false)
		head_stack.scale.x = 1
	
	if current_dir != Vector2():
		anim_player.play("running")
	else:
		anim_player.play("idle")
