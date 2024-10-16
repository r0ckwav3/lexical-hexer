extends Button

const StoreManager = preload("res://Scripts/StoreManager.gd")

@export var title: String
@export var cost: int
@export var description: String
var purchased := false
var storemanager: StoreManager

# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	pressed.connect(_on_pressed)

func update_text():
	if purchased:
		get_child(0).get_child(0).text = title + " - " + str(cost) + "G (Purchased)"
	else:
		get_child(0).get_child(0).text = title + " - " + str(cost) + "G"
	get_child(0).get_child(1).text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	if (not purchased) and storemanager.can_purchase(cost):
		storemanager.purchase_upgrade(title, cost)
		purchased = true
		update_text()
