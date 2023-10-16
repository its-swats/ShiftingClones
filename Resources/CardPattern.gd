extends Resource
class_name CardPattern

@export var TopRow: Array[GameTile.TileID]
@export var MidRow: Array[GameTile.TileID]
@export var BotRow: Array[GameTile.TileID]
@export var points: int = 0

func pattern():
	return [
		BotRow,
		MidRow,
		TopRow,
	]
