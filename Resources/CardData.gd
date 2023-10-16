extends Resource
class_name CardData

@export var points: int = 1
@export var pattern: Array

func _init(data):
	pattern = data.pattern()
	points = data.points
