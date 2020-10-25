extends Node

export var border_color = Color8(255, 255, 255, 255)

func _ready():
	for border in get_children():
		border.get_node("ColorRect").color = border_color
