extends Area2D
class_name Card

signal card_discarded(card: Card)
signal card_scored(card: Card)

const lookup = {
	GameTile.TileID.A: 'A',
	GameTile.TileID.B: 'B',
	GameTile.TileID.C: 'C',
	GameTile.TileID.D: 'D',
	GameTile.TileID.E: 'E',
	GameTile.TileID.F: 'F',
	GameTile.TileID.G: 'G',
	GameTile.TileID.H: 'H',
	GameTile.TileID.X: '',
}

@export var glow_shader: Material = null
var draggable = false
var dragging = false
var moving = false
var offset
var reset_pos
var over_discard = false
var card_data: CardData
var scorable = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func set_up(data):
	self.card_data = data
	$'Sprite2D/Control/Score'.text = str(card_data.points)
	var idx = 1
	var internal_idx = 1
	for row in card_data.pattern:
		for cell in row:
			var field = $"Sprite2D/Control/MarginContainer/VBoxContainer"
			var label = field.get_node(str("Row", idx, "/Col", (internal_idx - 1) % 3 + 1))
			if label:
				label.get_parent().visible = true
				label.visible = true
				label.text = lookup[cell]
			internal_idx += 1
		idx += 1

func _process(_delta):
	if(draggable && !dragging && !moving && Input.is_action_just_pressed('click')):
		start_drag()
	elif(dragging && Input.is_action_pressed('click')):
		follow_mouse()
	elif(dragging && Input.is_action_just_released('click')):
		stop_drag()

func _on_mouse_entered():
	draggable = true
	if(!moving):
		get_tree().create_tween().tween_property(self, 'scale', Vector2(1.1, 1.1), 0.1)
	
func _on_mouse_exited():
	draggable = false
	get_tree().create_tween().tween_property(self, 'scale', Vector2(1, 1), 0.1)

func _on_area_entered(_area):
	over_discard = true

func _on_area_exited(_area):
	over_discard = false

func init():
	reset_pos = position

func start_drag():
	offset = get_global_mouse_position() - global_position
	dragging = true
	moving = true
	get_parent().move_child(self, -1)

func follow_mouse():
	position = get_global_mouse_position() - offset

func stop_drag():
	dragging = false
	if(over_discard):
		get_parent().remove_child(self)
		card_discarded.emit(self)
		queue_free()
	else:
		await get_tree().create_tween().tween_property(self, 'position', reset_pos, 0.2).finished
	moving = false

func set_scorable():
	scorable = true
	$Sprite2D.material = glow_shader
	
func set_unscorable():
	scorable = false
	$Sprite2D.material = null
