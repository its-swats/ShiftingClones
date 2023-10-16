class_name MatchFinder

var checks = []
var start_type
var start_pos: Vector2
var valid = false


func _init(card: Card, tiles: Array):
	build_pattern_data(card)
	find_match(tiles)

func is_valid():
	return valid

func build_pattern_data(card):
	var y = 0
	for row in card.card_data.pattern:
		var x = 0
		for c in row:
			if c == GameTile.TileID.X:
				pass
			elif c != null && start_type == null:
				start_type = c
				start_pos = Vector2(x, y)
			else:
				checks.append([Vector2(x - start_pos.x, y - start_pos.y), c])
			x += 1
		y += 1

func find_match(tiles):
	var y = 0
	for row in tiles:
		var x = 0
		for col in row:
			if col.current_tile.id == start_type:
				var search = search_local(tiles, x, y)
				if search:
					valid = true
					return
			x+= 1
		y += 1
	valid = false

func search_local(tiles, x, y):
	var match_found = true
	for check in checks:
		var y_diff = check[0].y + x
		var x_diff = check[0].x + y
		if(x_diff > 2 || y_diff > 2 || x_diff < 0 || y_diff < 0):
			match_found = false
			break
		elif(tiles[x_diff][y_diff].current_tile.id == check[1]):
			pass
		else:
			match_found = false
	return match_found
