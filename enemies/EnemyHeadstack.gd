extends Position2D

var head_coin = preload("res://player/HeadCoin.tscn")

var coin_count setget update_coin_count

func _ready():
	update_coin_count(get_parent().max_health)

func update_coin_count(new_count):
	coin_count = new_count
	for coin in self.get_children():
		coin.queue_free()
	for i in range(0, new_count):
		var new_coin = head_coin.instance()
		add_child(new_coin)
		new_coin.position.y = -4 * i
		i += 1
