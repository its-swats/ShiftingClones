extends Node2D

const padding_left = 26
const padding_bottom = 825

func place_card(card):
	add_child(card)
	organize_hand()

func organize_hand():
	var idx = 0
	for card in get_children():
		var size = card.get_node('Sprite2D').texture.get_size()
		var extra_padding_left = 9 * idx
		card.position = Vector2(
			padding_left + extra_padding_left + (size.x / 2) + (size.x * idx),
			padding_bottom,
		)
		card.init()
		idx += 1
