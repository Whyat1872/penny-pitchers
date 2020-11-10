extends Area2D

signal upgrade_selected

onready var anim_player = $AnimationPlayer

export var upgrade_target = "stat"
export var upgrade_target_value = 1

var kill_speed = 200

var coin_drop = preload("res://player/projectiles/CopperProjectile.tscn")

func _ready():
	anim_player.play("idle")
	get_node("CollisionShape2D").set_deferred("disabled", true)
	connect("upgrade_selected", get_parent(), "close_shop")
	yield(get_tree().create_timer(1), "timeout")
	get_node("CollisionShape2D").set_deferred("disabled", false)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.can_interact:
			emit_signal("upgrade_selected")
			anim_player.play("selected")
			yield(anim_player, "animation_finished")
			print("%s +%s" % [upgrade_target, upgrade_target_value])
			queue_free()
	elif body.is_in_group("projectile") and body.can_kill == true:
		if body.linear_velocity.length() >= kill_speed:
			emit_signal("upgrade_selected")
			anim_player.play("selected")
			yield(anim_player, "animation_finished")
			print("%s +%s" % [upgrade_target, upgrade_target_value])
			queue_free()
