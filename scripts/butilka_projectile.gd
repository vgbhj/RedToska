extends Node2D

@export var on_ready = false
@export var speed = 1.5
@export var height = 300
var start_pos: Vector2
var end_pos: Vector2
var point_1: Vector2
@export var direct: int = 1 
var t = 0.0

func _ready():
	start_pos = global_position
	end_pos = global_position
# Called when the node enters the scene tree for the first time.

func on_ready_f():
	
	end_pos.y = global_position.y - 30
	point_1.x = abs(end_pos.x + start_pos.x) / 2
	point_1.y = start_pos.y - height
	on_ready = true
	#print(start_pos, point_1, end_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !on_ready: return
	t += delta * speed
	
	var m1 = start_pos.lerp(point_1, t)
	var m2 = point_1.lerp(end_pos, t)
	global_position = m1.lerp(m2, t)
		
	
	if global_position.y - 30 >= end_pos.y:
		queue_free()
