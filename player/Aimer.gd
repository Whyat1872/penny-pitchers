extends Position2D

onready var player_ref = get_parent()

export(Array, PackedScene) var projectiles
var projectile_speed = 1000
var fire_rate = 0.25
var can_fire = true

var deadly_speed_min = Vector2(-500, -500)

var laser_level = 0

func _ready():
	upgrade_laser(0)

func upgrade_laser(new_level):
	laser_level = new_level
	match new_level:
		0:
			for child in get_children():
				child.visible = false
		1:
			$Sprite.visible = true
		2:
			$Sprite.region_rect.position = Vector2(8, 0)
			$Sprite2.visible = true
		3:
			$Sprite2.region_rect.position = Vector2(8, 0)
			$Sprite3.visible = true
		4:
			$Sprite3.region_rect.position = Vector2(8, 0)
			$Sprite4.visible = true
		5:
			$Sprite4.region_rect.position = Vector2(8, 0)
			$Sprite5.visible = true

func _process(delta):
	if player_ref.is_alive:
		look_at(get_global_mouse_position())
		for child in get_children():
			child.set_global_rotation(0)
#		$Sprite.set_global_rotation(0)
	
		if Input.is_action_pressed("shoot") and can_fire:
			if player_ref.current_coins > 0:
				if player_ref.current_coins <= 2:
					player_ref.interact_audio_player.play_audio("low_ammo")
				else:
					player_ref.interact_audio_player.play_audio("shoot")
				player_ref.player_hit("shoot")
				var new_projectile = projectiles[0].instance()
				new_projectile.thrower = get_parent()
				new_projectile.position = $Sprite.get_global_position()
				new_projectile.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
				get_tree().get_root().get_node("World/Items").add_child(new_projectile)
				can_fire = false
				yield(get_tree().create_timer(fire_rate),"timeout")
				can_fire = true
			else:
				print("out of $")
				can_fire = false
				yield(get_tree().create_timer(fire_rate),"timeout")
				can_fire = true
