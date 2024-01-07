extends Marker2D

@export var time_berofe_spawn: int = 0
var enemy_scene = preload("res://scenes/enemy_punk.tscn") 
var enemy_instance
var isStart = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_instance = enemy_scene.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_child_count() < 1 && isStart:
		queue_free()

func spawn_enemy():
	await get_tree().create_timer(time_berofe_spawn).timeout
	add_child(enemy_instance)
	isStart = true
