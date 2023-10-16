extends Area2D
class_name TilePiece

signal tile_clicked(position: Vector2)
signal drag_started(position: Vector2)
signal drag_ended(position: Vector2)

var current_tile
var grid_position
var highlighted = false
var pressed_last_frame = false
var locked = false

func _ready():
	input_event.connect(on_input_event)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func _input(event: InputEvent):
	if(event is InputEventMouseButton && State.can_act() && highlighted && !event.pressed):
		drag_ended.emit(grid_position)

func init(tile: GameTile):
	current_tile = tile
	set_texture()
	
func flip():
	if(locked):
		return
	lock(0.2)
	await get_tree().create_tween().tween_property($Sprite2D, 'scale', Vector2(0, 1), .1).set_ease(Tween.EASE_IN).finished
	current_tile.flip()
	set_texture()
	await get_tree().create_tween().tween_property($Sprite2D, 'scale', Vector2(1, 1), .1).set_ease(Tween.EASE_OUT).finished

func set_texture():
	$Sprite2D.texture = current_tile.get_texture()

func on_input_event(_viewport, event, _shape):
	if(locked || !State.can_act()):
		return
	elif(event is InputEventMouseButton && !pressed_last_frame && event.pressed):
		print('Pressed')
		pressed_last_frame = true
		drag_started.emit(grid_position)
	elif(event is InputEventMouseButton && pressed_last_frame && !event.pressed):
		print('Released')
		tile_clicked.emit(grid_position)
		pressed_last_frame = false
	else:
		pressed_last_frame = false

func on_mouse_entered():
	highlighted = true
	
func on_mouse_exited():
	highlighted = false
	
func lock(length):
	locked = true
	await get_tree().create_timer(length).timeout
	locked = false
	pressed_last_frame = false
	
