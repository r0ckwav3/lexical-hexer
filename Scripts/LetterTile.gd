extends "res://Scripts/Draggable.gd"
const LetterTileSlot = preload("res://Scripts/LetterTileSlot.gd")

var intial_position := Vector2.ZERO
var slot: LetterTileSlot

@export var letter := "Z"
@export var score := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	(find_child("LetterLabel") as Label).text = letter
	(find_child("LetterScoreLabel") as Label).text = str(score)
	
	intial_position = global_position
	dragging_ended.connect(_on_dragging_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func _on_dragging_ended():	
	var area2d = find_child("Area2D") as Area2D
	var bestlts: LetterTileSlot = null
	var bestdist := 0.0
	for other in area2d.get_overlapping_areas():
		var lts = other.get_parent() as LetterTileSlot
		if lts:
			var dist = (global_position - lts.global_position).length()
			if (bestlts == null) or bestdist > dist:
				bestlts = lts
				bestdist = dist
	change_slot(bestlts)
	
	if slot:
		global_position = slot.global_position
	else:
		global_position = intial_position

func change_slot(new_slot: LetterTileSlot):
	if slot:
		slot.reset()
	if new_slot:
		new_slot.set_tile(self)
	slot = new_slot

func unslot():
	change_slot(null)
	global_position = intial_position
