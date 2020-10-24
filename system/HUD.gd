extends CanvasLayer

onready var main_label = get_node("MainLabel")
var kill_count = 0

func _ready():
	main_label.text = "kills: %s" % [kill_count]

func update_kill_count():
	kill_count += 1
	main_label.text = "kills: %s" % [kill_count]
