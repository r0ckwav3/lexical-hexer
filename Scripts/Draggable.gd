extends Node2D

signal dragging_started()
signal dragging_ended()

var mouse_d := Vector2(0,0)
var dragging := false

func _ready():
	pass

func _process(delta):
	if dragging:
		var mousepos := get_viewport().get_mouse_position()
		position = mousepos + mouse_d;

func _on_area_2d_input_event(viewport, event, shape_idx):
	var emb := event as InputEventMouseButton
	if not emb:
		return
	elif emb.get_button_index() == MOUSE_BUTTON_LEFT and emb.is_pressed():
		dragging = true
		dragging_started.emit()
		mouse_d = position - emb.get_global_position()
	elif emb.get_button_index() == MOUSE_BUTTON_LEFT and not emb.is_pressed() and dragging:
		dragging = false
		dragging_ended.emit()
	
