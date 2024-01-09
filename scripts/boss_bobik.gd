extends CharacterBody2D

class_name Bobik

signal healthChanged
signal enemy_death

#	3		1
#		5
#	2		4
@export var dot1: Marker2D
@export var dot2: Marker2D
@export var dot3: Marker2D
@export var dot4: Marker2D
@export var dot5: Marker2D
@export var speed = 500
@export var hit_window = 4
#@onready var player = get_tree().root.get_child(0).get_child(0).get_node("Player")
@onready var animations = $AnimatedSprite2D/AnimationEnemy
@onready var collider = $Collider
@onready var MentTimer = $MentTimer
@onready var audio = $hitSFX

var ment = preload("res://scenes/ment.tscn")

@export var maxHealth = 50
@onready var currentHealth: int = maxHealth

var lastAnimDirection: String = "Left"
var isDead: bool = false
var isTakeDamage: bool = false
var inAttackZone: bool = false
var isAttacking: bool = false
var isStart: bool = false

var stage: int = 1

func updateAnimation():
	if stage == 4:
		animations.play("idle")
	if stage == 1:
		animations.play("walk_to_left")
	if stage == 2 or stage == 3:
		animations.play("walk_to_right")

func move_to_player():
	velocity = Vector2.ZERO
	if stage == 1:
		velocity = global_position.direction_to(dot2.global_position) * speed
		if abs((global_position - dot2.global_position).x) < 5 and  abs((global_position - dot2.global_position)).y < 5:
			global_position = dot3.global_position
			stage = 2
	if stage == 2:
		velocity = global_position.direction_to(dot5.global_position) * speed
		if abs((global_position - dot5.global_position)).x < 5 and abs((global_position - dot5.global_position)).y < 5:
			MentTimer.stop()
			stage = 4
			await get_tree().create_timer(hit_window).timeout
			stage = 3
			MentTimer.start()
	if stage == 3:
		velocity = global_position.direction_to(dot4.global_position) * speed
		if abs((global_position - dot4.global_position)).x < 5 and abs((global_position - dot4.global_position)).y < 5:
			global_position = dot1.global_position
			stage = 1
			
	#if global_position.distance_to(player.get_child(0).get_child(0).global_position) > distanceBetweenPlayer:
		#velocity = global_position.direction_to(player.get_child(0).get_child(0).global_position) * speed

func _ready():
	global_position = dot5.global_position + Vector2(200,0)
	
func start_fight():
	isStart = true
	MentTimer.start()

func _physics_process(delta):
	if !isStart: return
	if isTakeDamage: return
	if isDead: return
	if isAttacking: return
	
	move_to_player()
	updateAnimation()
	if stage != 4:
		move_and_slide()

func _on_hurt_box_area_entered(area):
	if !area.is_in_group("jabAttack") \
	and !area.is_in_group("true_jabAttack") \
	and !area.is_in_group("jumpAttack") \
	and !area.is_in_group("superAttack"): return
	var damage = 0
	if area.is_in_group("true_jabAttack"):
		damage = 1
	if area.is_in_group("jabAttack"):
		damage = 2
	if area.is_in_group("jumpAttack"):
		damage = 3
	if area.is_in_group("superAttack"):
		damage = 4
	currentHealth -= damage
	audio.play()
	healthChanged.emit(currentHealth)
	if currentHealth < 1:
		isDead = true
		enemy_death.emit()
		animations.play("death")
		await animations.animation_finished
		await get_tree().create_timer(5).timeout
		get_tree().change_scene_to_file("res://scenes/end.tscn")
		queue_free()


func _on_ment_timer_timeout():
	var ment_ins = ment.instantiate()
	get_parent().add_child(ment_ins)
	get_parent().move_child(ment_ins, 0)
	get_parent().get_child(0).global_position = global_position
	get_parent().get_child(0).isBropHilka = true


func _on_boss_level_start_fight():
	isStart = true
	MentTimer.start()
