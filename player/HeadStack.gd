extends Position2D

var coinstack_array = []

var head_coin = preload("res://player/HeadCoin.tscn")

var coin_count setget update_coin_count

func update_coin_count(new_count):
	for coin in self.get_children():
		coin.queue_free()
	var i = 0
	while i < new_count:
		var new_coin = head_coin.instance()
		add_child(new_coin)
		new_coin.position.y = -4 * i
		i += 1

func stack_coin(value):
	var new_coin = head_coin.instance()
	add_child(new_coin)
	match value:
		1:
			pass
		3:
			pass
		5:
			pass
