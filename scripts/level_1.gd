extends Node2D

@export var spanwers : Spawners
@export var trigger: Area2D
var enemy_scene = preload("res://scenes/enemy_punk.tscn") 
var isWaveStart: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spanwers.get_child_count() == 0:
		queue_free()

func _on_level_area_body_entered(body):
	if !body.is_in_group("player"): return
	if isWaveStart: return
	print("Start Wave!")
	for i in spanwers.get_children():
		i.spawn_enemy()
	isWaveStart = true
