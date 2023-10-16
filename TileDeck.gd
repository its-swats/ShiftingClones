var tiles: Array[GameTile] = [
	preload("res://Resources/GameTiles/Tile1.tres"),
	preload("res://Resources/GameTiles/Tile2.tres"),
	preload("res://Resources/GameTiles/Tile3.tres"),
	preload("res://Resources/GameTiles/Tile4.tres"),
	preload("res://Resources/GameTiles/Tile5.tres"),
	preload("res://Resources/GameTiles/Tile6.tres"),
	preload("res://Resources/GameTiles/Tile7.tres"),
	preload("res://Resources/GameTiles/Tile8.tres"),
	preload("res://Resources/GameTiles/Tile9.tres"),
]

func generate_board() -> Array[GameTile]:
	tiles.shuffle()
	for tile in tiles:
		tile.init()
	return tiles
	
