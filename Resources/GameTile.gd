extends Resource
class_name GameTile

enum TileID { A, B, C, D, E, F, G, H, X }

@export var texture_front: Texture
@export var texture_back: Texture
@export var front_id: TileID
@export var back_id: TileID

var id

func init():
	id = [front_id, back_id].pick_random()

func get_texture() -> Texture:
	return texture_front if id == front_id else texture_back

func flip():
	if id == front_id:
		id = back_id
	else:
		id = front_id
