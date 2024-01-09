extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
