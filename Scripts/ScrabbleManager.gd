extends Node2D

signal submitted_word(word: String, value: int)

@export var TileScn: PackedScene
@export var TileSlotScn: PackedScene
@export var ErrorMessageScn: PackedScene

@export var slot_count := 4
@export var letter_bag_size := 5
@export var free_blanks := 0

var max_slot_separation := 150.0
var max_word_width := 1210.0

var tile_separation := 200.0
var tile_jitter := 30.0
var tile_row_len := 6

var slot_parent: Node2D
var tile_parent: Node2D
var error_source: Node2D

var tile_data: Array
var total_tile_count: int

var legal_words = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	slot_parent = find_child("Slots") as Node2D
	tile_parent = find_child("Tiles") as Node2D
	error_source = find_child("ErrorSource") as Node2D
	
	var tile_json = load("res://Data/tiles.json")
	assert(typeof(tile_json.data) == TYPE_ARRAY)
	tile_data = tile_json.data
	
	for row in tile_data:
		total_tile_count += row["count"]
	
	_reset_slots_tiles()
	_setup_slots()
	_setup_tiles()
	_load_words()

func _load_words():
	var file := FileAccess.open("res://Data/2019scrabblewords.txt", FileAccess.READ)
	while file.get_position() < file.get_length():
		var line: String = file.get_line().strip_edges()
		if line.length() != 0:
			legal_words[line] = true
	print("finished loading words")

func _reset_slots_tiles():
	for o in slot_parent.get_children():
		o.queue_free()
	for o in tile_parent.get_children():
		o.queue_free()

func _setup_slots():
	var slot_separation: float = min(max_slot_separation, max_word_width/(slot_count-1))
	for i in range(slot_count):
		var new_slot = TileSlotScn.instantiate()
		new_slot.position = Vector2(i*slot_separation, 0.0)
		slot_parent.add_child(new_slot)

func _setup_tiles():
	var chosen_tiles = []
	for i in range(letter_bag_size):
		chosen_tiles.append(_select_tile())
	for i in range(free_blanks):
		chosen_tiles.append({"letter": " ", "score": 0})
	
	chosen_tiles.shuffle()
	
	var rng = RandomNumberGenerator.new()
	for i in range(len(chosen_tiles)):
		var tile_info = chosen_tiles[i]
		var x = ((i % tile_row_len) * tile_separation) + rng.randf_range(-tile_jitter, tile_jitter)
		var y = (int(i / tile_row_len) * tile_separation) + rng.randf_range(-tile_jitter, tile_jitter)
		
		var new_tile = TileScn.instantiate()
		new_tile.letter = tile_info["letter"]
		new_tile.score = tile_info["score"]
		new_tile.position = Vector2(x, y)
		tile_parent.add_child(new_tile)
		

func _select_tile():
	var index = randi_range(1,total_tile_count)
	for row in tile_data:
		if index <= row["count"]:
			return row
		else:
			index -= row["count"]
	assert(false)

func attempt_submit_word():
	if _has_gaps():
		_show_error("Malformed word")
		return
		
	var word := get_word()
	var score := get_score()
	if len(word) == 0:
		_show_error("Create a word first")
	elif len(word) >= 2 and (not legal_words.has(word)):
		_show_error("Invalid word")
	else:
		# valid word or single letter
		submitted_word.emit(word, score * word.length())
		_reset_slots_tiles()
		_setup_slots()
		_setup_tiles()

func _show_error(message: String):
	var o = ErrorMessageScn.instantiate()
	error_source.add_child(o)
	o.set_message(message)
	o.position = Vector2.ZERO

func _has_gaps():
	var seen_blank = false
	for slot in slot_parent.get_children():
		if slot.get_letter() == "":
			seen_blank = true
		elif seen_blank:
			# nonblank after blank
			return true
	return false

func get_word() -> String:
	var word: String = ""
	for slot in slot_parent.get_children():
		word += slot.get_letter()
	return word

func get_score() -> int:
	var score := 0
	for slot in slot_parent.get_children():
		score += slot.get_score()
	return score
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func increment_letters():
	letter_bag_size += 1
	_reset_slots_tiles()
	_setup_slots()
	_setup_tiles()

func increment_slots():
	slot_count += 1
	_reset_slots_tiles()
	_setup_slots()
	_setup_tiles()


func increment_blanks():
	free_blanks += 1
	_reset_slots_tiles()
	_setup_slots()
	_setup_tiles()
