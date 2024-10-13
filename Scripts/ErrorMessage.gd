extends Node2D

var label: Label
var timer: Timer

@export var float_height := 100

# Called when the node enters the scene tree for the first time.
func _ready():
	label = find_child("Label")
	timer = find_child("Timer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var alpha = timer.time_left / timer.wait_time
	label.modulate = Color(1,1,1,alpha)
	label.position.y = float_height * alpha


func _on_timer_timeout():
	queue_free()

func set_message(message: String):
	label.text = message
