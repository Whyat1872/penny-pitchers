extends KinematicBody2D

export var speed = 250

onready var anim_player = $AnimationPlayer
onready var head_stack = $HeadStack

var current_coins = 0

func _input(_event):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_up"):
		direction += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		direction += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		direction += Vector2(1, 0)
	
	animation_handler(direction)
	if current_coins > 0:
		move_and_slide(direction * (speed / current_coins))
	else:
		move_and_slide(direction * speed)

func add_coin(value):
	current_coins += value
	head_stack.coin_count = current_coins

func animation_handler(current_dir):
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
