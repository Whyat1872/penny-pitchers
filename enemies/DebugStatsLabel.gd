extends Label

var debug_string = "HP: %01d/%01d | LT: %01d"

func _ready():
	update_label(0, 0, 0)

func update_label(c_health, m_health, loot):
	text = debug_string % [c_health, m_health, loot]
