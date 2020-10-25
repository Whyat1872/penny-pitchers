extends RigidBody2D

export var value = 1

var can_kill = true

func _physics_process(delta):
	$Sprite.set_global_rotation(0)

func _on_body_entered(body):
	pass # Replace with function body.
