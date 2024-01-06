extends HBoxContainer

@onready var HeartGuiClass = preload("res://scenes/heartGui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)
		move_child(heart, i)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	print(currentHealth)
	
	for i in range(currentHealth):
		hearts[i].update(true)
	
	for i in range(currentHealth, hearts.size()-1):
		hearts[i].update(false)
