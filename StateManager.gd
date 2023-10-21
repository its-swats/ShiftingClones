extends Node
class_name StateManager

signal update_points(amount: int)
signal update_actions(amount: int)
signal next_turn()

var points: int = 0
var actions: int = 0
	
func score(card: CardData):
	points += card.points
	update_points.emit(points)

func can_act():
	return actions >= 1

func discard():
	actions += 1
	update_actions.emit(actions)

func acted():
	actions -= 1
	update_actions.emit(actions)

func end_turn():
	next_turn.emit()
