extends CanvasLayer

onready var main_label = get_node("MainLabel")
var kill_count = 0

func _ready():
	yield(get_tree().create_timer(1.5), "timeout")
	main_label.text = "defeated: %s" % [kill_count]

func update_kill_count():
	kill_count += 1
	main_label.text = "defeated: %s" % [kill_count]
