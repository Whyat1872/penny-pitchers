extends Node2D

signal shop_closed

onready var player_ref = get_parent().get_node("YSort/Player")

func _ready():
	position = Vector2(512, 192)
	for child in get_children():
		if child.has_node("CollisionShape2D"):
			child.anim_player.play("idle")
			child.connect("upgrade_selected", self, "close_shop")
	if player_ref.get_node("Aimer").laser_level >= 5:
		$LaserUpgrade.queue_free()

func _exit_tree():
	emit_signal("shop_closed", get_parent().get_node("EnemySpawnArea"), "resume_spawning")

func close_shop():
	for child in get_children():
		if child.has_node("CollisionShape2D"):
			child.get_node("CollisionShape2D").set_deferred("disabled", true)
		child.visible = false
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
