var patterns = [
	preload('res://Resources/CardPatterns/1.tres'),
	preload('res://Resources/CardPatterns/2.tres'),
	preload('res://Resources/CardPatterns/3.tres'),
	preload('res://Resources/CardPatterns/4.tres'),
	preload('res://Resources/CardPatterns/5.tres'),
	preload('res://Resources/CardPatterns/6.tres'),
	preload('res://Resources/CardPatterns/7.tres'),
	preload('res://Resources/CardPatterns/8.tres'),
	preload('res://Resources/CardPatterns/9.tres'),
	preload('res://Resources/CardPatterns/10.tres'),
]

var deck = []
var card_data = preload('res://Resources/CardData.gd')

func _init():
		generate_deck()

func generate_deck():
	patterns.shuffle()
	for i in patterns:
		deck.append(
			card_data.new(i)
		)	

func any_cards_left():
	return deck.size() > 0

func deal():
	if(deck.size() > 0):
		return deck.pop_front()
	else:
		return null
