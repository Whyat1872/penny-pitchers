extends Node2D

signal shop_closed

func _exit_tree():
	emit_signal("shop_closed", get_parent().get_node("EnemySpawnArea"), "resume_spawning")

func close_shop():
	for child in get_children():
		if child.has_node("CollisionShape2D"):
			child.get_node("CollisionShape2D").set_deferred("disabled", true)
		child.visible = false
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
