extends Control

@export var money := 0
@export var scrabble_manager: Node

var toggle_store_button: Control
var button_container: Control
var store_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_store_button = find_child("ToggleStoreButton")
	button_container = find_child("ButtonContainer")
	for button in button_container.get_children():
		button.storemanager = self
	update_money(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func can_purchase(cost: int):
	return (money >= cost)

func update_money(delta:int):
	money += delta
	toggle_store_button.text = "Store (" + str(money) + "G)"

func purchase_upgrade(name: String, cost: int):
	update_money(-cost)
	print("purchased " + name)
	if name == "More Letters":
		scrabble_manager.increment_letters()
	if name == "Longer Words":
		scrabble_manager.increment_slots()
	if name == "More Blanks":
		scrabble_manager.increment_blanks()

func _on_toggle_store_button_pressed():
	if store_visible:
		store_visible = false
	else:
		store_visible = true
	button_container.visible = store_visible


func _on_adventure_queue_adventure_finished(value):
	update_money(value)
