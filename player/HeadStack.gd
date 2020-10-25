extends Position2D

var head_coin = preload("res://player/HeadCoin.tscn")

var coin_count setget update_coin_count

func _ready():
	update_coin_count(get_parent().current_coins)

func update_coin_count(new_count):
	coin_count = new_count
	for coin in self.get_children():
		coin.queue_free()
	var i = 0
	while i < new_count:
		var new_coin = head_coin.instance()
		add_child(new_coin)
		new_coin.position.y = -4 * i
		i += 1
