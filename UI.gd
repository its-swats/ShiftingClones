extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	State.update_points.connect(_on_update_points)
	State.update_actions.connect(_on_update_actions)
	$Button.button_up.connect(_on_next_turn)
	
func _on_update_points(points):
	$Score.text = str(points)
	
func _on_update_actions(actions):
	$Actions.text = str(actions)
	
func _on_next_turn():
	if(State.actions == 0):
		State.end_turn()
