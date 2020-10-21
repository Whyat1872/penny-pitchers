extends Area2D

onready var anim_player = $AnimationPlayer
var coin_drop = preload("res://interactables/money/CollectableCoin.tscn")

var player_ref 

var speed = 100

var velocity = Vector2()

var kill_speed = 200

func _ready():
	player_ref = get_tree().get_root().get_node("World/YSort/Player")
	anim_player.play("moving")

func _process(delta):
	velocity = global_position.direction_to(player_ref.global_position)

	global_position += velocity * speed * delta

func death():
	var dropped_loot = coin_drop.instance()
	dropped_loot.position = get_global_position()
	get_tree().get_root().get_node("World").call_deferred("add_child", dropped_loot)

func _on_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	elif body.is_in_group("projectile"):
		if body.linear_velocity.length() >= kill_speed:
			body.queue_free()
			death()
			queue_free()
