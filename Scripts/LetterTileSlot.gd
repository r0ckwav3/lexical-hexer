extends Node2D
const LetterTile = preload("res://Scripts/LetterTile.gd")

var curr_tile: LetterTile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_tile(tile: LetterTile):
	if curr_tile:
		curr_tile.unslot()
	curr_tile = tile

func get_tile():
	return curr_tile
	
func reset():
	curr_tile = null

func get_letter():
	if curr_tile:
		return curr_tile.letter
	else:
		return ""

func get_score():
	if curr_tile:
		return curr_tile.score
	else:
		return 0

func is_power_tile():
	if curr_tile:
		return curr_tile.is_power_tile
	else:
		return false
