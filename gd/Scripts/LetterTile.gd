extends "res://Scripts/Draggable.gd"
const LetterTileSlot = preload("res://Scripts/LetterTileSlot.gd")

var intial_position := Vector2.ZERO
var slot: LetterTileSlot

@export var power_tile_back: Texture2D

@export var letter := "Z"
@export var score := 10
@export var is_power_tile := false
var is_blank := false
var blank_inputting := false

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	update_labels()
	if letter == " ":
		is_blank = true
		var font_color = Color("b700a1")
		find_child("LetterLabel").set("theme_override_colors/font_color", font_color)
	
	if is_power_tile:
		find_child("TileBack").texture = power_tile_back
	
	intial_position = global_position
	dragging_ended.connect(_on_dragging_ended)

func update_labels():
	(find_child("LetterLabel") as Label).text = letter
	(find_child("LetterScoreLabel") as Label).text = str(score)

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

func _on_area_2d_input_event(viewport, event, shape_idx):
	super(viewport, event, shape_idx)
	var emb := event as InputEventMouseButton
	if not emb:
		return
	elif emb.get_button_index() == MOUSE_BUTTON_LEFT and emb.is_double_click():
		if is_blank:
			letter = "_"
			blank_inputting = true
			update_labels()

func _unhandled_key_input(ev):
	if blank_inputting:
		if ev is InputEventKey and ev.pressed:
			var keycode = ev.as_text_keycode()
			var alpharegex = RegEx.new()
			alpharegex.compile("^[A-Z]$")
			if alpharegex.search(keycode):
				letter = keycode
				blank_inputting = false
				update_labels()

func change_slot(new_slot: LetterTileSlot):
	if slot:
		slot.reset()
	if new_slot:
		new_slot.set_tile(self)
	slot = new_slot

func unslot():
	change_slot(null)
	global_position = intial_position
