extends Control

signal adventure_finished(value: int)

@export var adventure_timer: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: maybe have variable times for words?
func start_adventure(word, value):
	var at = adventure_timer.instantiate()
	at.title = word
	at.value = value
	at.finished.connect(finish_adventure)
	get_child(0).add_child(at)

func finish_adventure(value):
	adventure_finished.emit(value)
