extends Button

const StoreManager = preload("res://Scripts/StoreManager.gd")

@export var title: String
@export var base_cost := 50
@export var cost_scale := 2
@export var max_tier := 0
@export var description: String
var tier = 1
var purchased := false
var storemanager: StoreManager

# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	pressed.connect(_on_pressed)

func update_text():
	if (max_tier == 0 or tier <= max_tier):
		get_child(0).get_child(0).text = title + " " + str(tier) + " - " + str(get_cost()) + "G"
	else:
		get_child(0).get_child(0).text = title + " (max)"
	get_child(0).get_child(1).text = description

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pressed():
	if (max_tier == 0 or tier <= max_tier) and storemanager.can_purchase(get_cost()):
		storemanager.purchase_upgrade(title, get_cost())
		tier += 1
		update_text()

func get_cost():
	return base_cost * pow(cost_scale, tier - 1)
