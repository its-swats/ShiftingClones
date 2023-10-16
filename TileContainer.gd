extends Node2D

const padding_left = 26
const padding_bottom = 700

func place_tile(tile, pos):
	var size = tile.get_node('Sprite2D').texture.get_size()
	var extra_padding_left = 7 * pos.x
	var extra_padding_bottom = 7 * pos.y
	add_child(tile)
	tile.position = Vector2(
		padding_left + extra_padding_left + (size.x / 4) + (size.x / 2 * pos.x),
		padding_bottom - extra_padding_bottom - (size.y / 4) - (size.y / 2 * pos.y),
	)

func swap_tiles(t1, t2):
	get_tree().create_tween().tween_property(t1, "position", t2.position, 0.25).set_ease(Tween.EASE_IN)
	get_tree().create_tween().tween_property(t2, "position", t1.position, 0.25).set_ease(Tween.EASE_IN)
	t1.lock(0.25)
	t2.lock(0.25)
