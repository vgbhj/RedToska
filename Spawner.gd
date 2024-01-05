extends Marker2D

var enemy_scene = preload("res://scenes/enemy_punk.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
