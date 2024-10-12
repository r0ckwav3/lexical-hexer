extends "res://Scripts/Draggable.gd"

var intial_position := Vector2.ZERO

@export var letter := "Z"
@export var score := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	(find_child("LetterLabel") as Label).text = letter
	(find_child("LetterScoreLabel") as Label).text = str(score)
	
	intial_position = position
	dragging_ended.connect(_on_dragging_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func _on_dragging_ended():
	position = intial_position
