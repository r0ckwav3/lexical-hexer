extends ColorRect

signal finished(value: int)

@export var progress_bar: ProgressBar
@export var timer: Timer
@export var label: Label

@export var title: String
@export var value: int
@export var duration: float

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = title
	timer.set_wait_time(duration)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = 1-(timer.time_left / timer.wait_time)
	progress_bar.value = 100 * progress


func _on_timer_timeout():
	finished.emit(value)
	queue_free()
