extends CharacterBody2D

signal enemy_death

var butilka_scene = preload("res://scenes/butilka_projectile.tscn") 
@export var speed = 200
@export var distanceBetweenPlayer = 300
@export var attack_interval = 3
@onready var player = get_tree().root.get_child(0).get_child(0).get_node("Player")
@onready var animations = $AnimatedSprite2D/AnimationEnemy
@onready var collider = $Collider

@export var maxHealth = 5
@onready var currentHealth: int = maxHealth

var lastAnimDirection: String = "Left"
var isDead: bool = false
var isTakeDamage: bool = false
var inAttackZone: bool = false
var isAttacking: bool = false

func mysign(fValue):
	if fValue < 0: 
		return -1 #negative
	elif fValue > 0: 
		return 1 #positive
	else:
		return 0 # zero  

func updateAnimation():
	if inAttackZone:
		var butilka = butilka_scene.instantiate()
		add_child(butilka)
		move_child(butilka, 0)
		butilka.end_pos.x = player.global_position.x
		#butilka.end_pos.y = player.global_position.y
		animations.play("jab_attack")
		get_child(0).on_ready_f()
		isAttacking = true
		await animations.animation_finished
		for i in range(attack_interval):
			animations.play("idle")
			await animations.animation_finished
		isAttacking = false
		
	if velocity == Vector2.ZERO:
		animations.play("idle")
		collider.position.x = $AnimatedSprite2D.position.x - 10
	else:
		animations.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x > 0
		
		var direction = "Left"
		if velocity.x < 0:
			direction = "Right"
			
		lastAnimDirection = direction
		
	
	if velocity.x == 0:
			if player.global_position.x < global_position.x:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
	
	collider.position.x = $AnimatedSprite2D.position.x

func move_to_player():
	velocity = Vector2.ZERO
	var player_pos_tmp = player.get_child(0).get_child(0).global_position
	#player_pos_tmp.x = global_position.x
	var absolute_distance = global_position.distance_to(player.get_child(0).get_child(0).global_position)
	#
	# x move
	#print(absolute_distance)
	#if abs(global_position.x - player_pos_tmp.x) > 300:
		#velocity.x = global_position.direction_to(player_pos_tmp).x * speed
	#
	# разделенное движение	
			
	var y_can = abs(global_position.y - player_pos_tmp.y) > 3
	var x_can = global_position.distance_to(player.get_child(0).get_child(0).global_position) > distanceBetweenPlayer
	if x_can and y_can:
		velocity = global_position.direction_to(player.get_child(0).get_child(0).global_position) * speed
	elif x_can: 
		velocity.x = mysign(global_position.direction_to(player_pos_tmp).x) * speed
	elif y_can:
		velocity.y = mysign(global_position.direction_to(player_pos_tmp).y) * speed
		
	#print((player_pos_tmp - global_position).y)
	#print(global_position.direction_to(player_pos_tmp).y)
	# как у панка
	#if global_position.distance_to(player.get_child(0).get_child(0).global_position) > distanceBetweenPlayer:
		#velocity = global_position.direction_to(player.get_child(0).get_child(0).global_position) * speed


func _physics_process(delta):
	if isTakeDamage: return
	if isDead: return
	if isAttacking: return
	
	move_to_player()
	updateAnimation()
	move_and_slide()

func _on_player_detecter_area_entered(area):
	if area.is_in_group("hurtBoxPlayer"):
		inAttackZone = true

func _on_player_detecter_area_exited(area):
	if area.is_in_group("hurtBoxPlayer"):
		inAttackZone = false

func _on_hurt_box_area_entered(area):
	if !area.is_in_group("hitBoxPlayer"): return
	currentHealth -= 1
	if currentHealth < 1:
		isDead = true
		enemy_death.emit()
		animations.play("death")
		await animations.animation_finished
		queue_free()
	else:
		isTakeDamage = true
		animations.play("hurt")
		await animations.animation_finished
		isTakeDamage = false
