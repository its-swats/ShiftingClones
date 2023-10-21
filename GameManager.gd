extends Node

@onready var tile_deck = preload("res://TileDeck.gd").new().generate_board()
@onready var tile_scene = preload("res://TilePiece.tscn")
@onready var card_deck = preload("res://CardDeck.gd").new()
@onready var card_scene = preload("res://Card.tscn")

var drag_start_pos
var drag_end_pos
var tiles = [
	[[], [], []],
	[[], [], []],
	[[], [], []]
]
var hand = []

func _ready():
	randomize()
	State.next_turn.connect(_on_next_turn)
	setup_board()
	deal_hand()
	find_matches()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func setup_board():
	var loop = 0
	for i in tile_deck:
		var new_tile = tile_scene.instantiate()
		var position = Vector2i(loop / 3, loop % 3)
		tiles[position.x][position.y] = new_tile
		new_tile.init(i)
		new_tile.grid_position = position
		new_tile.tile_clicked.connect(on_tile_clicked)
		new_tile.drag_started.connect(on_drag_started)
		new_tile.drag_ended.connect(on_drag_ended)
		$TileContainer.place_tile(new_tile, position)
		loop += 1

func deal_hand():
	while hand.size() < 4 && card_deck.any_cards_left():
		deal_card()

func deal_card():
	var card = card_deck.deal()
	if(card):
		var new_card = card_scene.instantiate()
		new_card.set_up(card)
		new_card.card_discarded.connect(_on_card_discarded)
		new_card.card_scored.connect(_on_card_scored)
		hand.append(new_card)
		$HandContainer.place_card(new_card)

func on_tile_clicked(pos: Vector2):
	await tiles[pos.x][pos.y].flip()
	clear_drag()
	State.acted()
	find_matches()

func on_drag_started(pos):
	drag_start_pos = pos
	
func on_drag_ended(pos):
	drag_end_pos = pos
	if adjacent_tiles(drag_start_pos, drag_end_pos):
		swap_tiles()
	clear_drag()
	
func _on_card_discarded(card: Card):
	State.discard()
	remove_card(card)

func _on_card_scored(card: Card):
	State.score(card.card_data)
	remove_card(card)
	
func adjacent_tiles(pos1, pos2):
	if (pos1 == null || pos2 == null):
		return false
	var h = [pos1.x, pos2.x]
	var v = [pos1.y, pos2.y]
	return ((h[0] == h[1] + 1 || h[0] == h[1] - 1) && v[0] == v[1]) || ((v[0] == v[1] + 1 || v[0] == v[1] - 1) && h[0] == h[1])
	
func swap_tiles():
	var t1 = tiles[drag_start_pos.x][drag_start_pos.y]
	var t2 = tiles[drag_end_pos.x][drag_end_pos.y]
	$TileContainer.swap_tiles(t1, t2)
	State.acted()
	t1.grid_position = drag_end_pos
	t2.grid_position = drag_start_pos
	tiles[drag_start_pos.x][drag_start_pos.y] = t2
	tiles[drag_end_pos.x][drag_end_pos.y] = t1
	find_matches()

func clear_drag():
	drag_start_pos = null
	drag_end_pos = null

func remove_card(card: Card):
	hand.remove_at(
		hand.find(card)
	)
	
func _on_next_turn():
	deal_hand()
	
func find_matches():
	for card in hand:
		var matcher = MatchFinder.new(card, tiles)
		print(matcher.is_valid())
		if matcher.is_valid():
			card.set_scorable()
		else:
			card.set_unscorable()
