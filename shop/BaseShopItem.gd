extends Area2D

signal upgrade_selected

onready var anim_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer2D

export var upgrade_target = "stat"
export var upgrade_target_value = 1.0

var kill_speed = 200

var coin_drop = preload("res://player/projectiles/CopperProjectile.tscn")

#func _ready():
#	anim_player.play("idle")
#	get_node("CollisionShape2D").set_deferred("disabled", true)
#	connect("upgrade_selected", get_parent(), "close_shop")
#	yield(get_tree().create_timer(1), "timeout")
#	get_node("CollisionShape2D").set_deferred("disabled", false)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.can_interact:
			body.player_did_shop(upgrade_target, upgrade_target_value)
			audio_player.play_audio("pickup")
			emit_signal("upgrade_selected")
			anim_player.play("selected")
			yield(anim_player, "animation_finished")
			print("%s +%s" % [upgrade_target, upgrade_target_value])
			queue_free()
	elif body.is_in_group("projectile") and body.can_kill == true:
		if body.linear_velocity.length() >= kill_speed:
			body.thrower.player_did_shop(upgrade_target, upgrade_target_value)
			audio_player.play_audio("pickup")
			emit_signal("upgrade_selected")
			anim_player.play("selected")
			handle_projectile_hit(body)
			yield(anim_player, "animation_finished")
			print("%s +%s" % [upgrade_target, upgrade_target_value])
			queue_free()

func handle_projectile_hit(projectile):
	var dropped_loot = coin_drop.instance()
	dropped_loot.position = get_global_position()
	projectile.queue_free()
	get_tree().get_root().get_node("World/Items").call_deferred("add_child", dropped_loot)
