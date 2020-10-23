extends Area2D

onready var anim_player = $AnimationPlayer

export var kill_speed = 200

var player_ref 
var coin_drop = preload("res://interactables/money/CollectableCoin.tscn")

var speed = 100
var velocity = Vector2()

export var max_health = 1
export var is_boss = false
var current_health

func _ready():
	print(int(is_boss))
	current_health = max_health
	speed = rand_range(90, 200)
	player_ref = get_tree().get_root().get_node("World/YSort/Player")
	anim_player.play("moving")

func _process(delta):
	velocity = global_position.direction_to(player_ref.global_position)
	
	if velocity.x < 0:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)

	global_position += velocity * speed * delta

func death():
	for i in range(0, max_health + int(is_boss)):
		var dropped_loot = coin_drop.instance()
		if is_boss:
			dropped_loot.position = get_global_position() + drop_offset()
		else:
			dropped_loot.position = get_global_position()
		get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
		i += 1

func drop_offset():
	var new_gen = RandomNumberGenerator.new()
	new_gen.randomize()
	var rand_angle = new_gen.randf_range(0, 359) # get random angle in radians
	var rand_radius = new_gen.randi_range(0, $CollisionShape2D.shape.radius)
	var coordinates = Vector2(cos(rand_angle), sin(rand_angle)) # find x and y vertices
	var spawn_pos = coordinates * rand_radius
	
	return spawn_pos

func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	elif body.is_in_group("projectile") and body.can_kill == true:
		if body.linear_velocity.length() >= kill_speed:
			current_health -= 1
			body.can_kill = false
			body.queue_free()
			if current_health <= 0:
				death()
				queue_free()
