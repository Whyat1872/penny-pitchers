extends YSort

var player_ref = null

func _ready():
	player_ref = get_node("Player")

func _on_player_death():
	var enemy_actors = get_children()
	enemy_actors.erase(player_ref)
	for child in enemy_actors:
		child.set_process(false)
