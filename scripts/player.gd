extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 300
@export var attack_interval = 1
@export var wait_after_jump = 3
@export var jump_impulse = 20
@onready var animations = $AnimatedSprite2D/AnimationPlayer
@onready var collider = $Collider
@onready var jabAttackCollider = $AnimatedSprite2D/JabAttack/JabAttackCollider
@onready var camera = $Camera2D

@export var maxHealth = 190
@onready var currentHealth: int = maxHealth

# для трпяски
@export var randomStrength: float = 30
@export var shakeFade: float = 5


var lastAnimDirection: String = "Left"
var isDead: bool = false
var isTakeDamage: bool = false
var inAttackZone: bool = false
var isAttacking: bool = false
var isJumping: bool = false
var waitNextJump: bool = false

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") and !isJumping:
		velocity.y += 1
	if Input.is_action_pressed("ui_up") and !isJumping:
		velocity.y -= 1
	
	if Input.is_action_just_pressed("jump") and !waitNextJump:
		jump()
	
	if Input.is_action_just_pressed("jab_attack"):
		if isJumping: return
		if lastAnimDirection == "Right":
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x - 40
		else:
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x + 10 
		
		animations.play("jab_attack")
		isAttacking = true
		await animations.animation_finished
		#for i in range(attack_interval):
			#animations.play("idle")
			#await animations.animation_finished
		isAttacking = false
		
	velocity = velocity.normalized() * speed

func updateAnimation():
	if isAttacking: return
	if isJumping: return
	if velocity == Vector2.ZERO:
		animations.play("idle")
		collider.position.x = $AnimatedSprite2D.position.x - 10
	else:
		animations.play("walk")
		if lastAnimDirection == "Left":
			$AnimatedSprite2D.flip_h = 0
		else:
			$AnimatedSprite2D.flip_h = 1
		
		var direction = "Left"
		if velocity.x < 0:
			direction = "Right"
		
		if velocity.x != 0:
			lastAnimDirection = direction
	
	collider.position.x = $AnimatedSprite2D.position.x


func _physics_process(delta):
	if isTakeDamage: return
	if isDead: return
	if isAttacking: return
	
	get_input()
	move_and_slide()
	updateAnimation()

func _on_hurt_box_area_entered(area):
	if !area.is_in_group("hitBox"): return
	currentHealth -= 1
	healthChanged.emit(currentHealth)
	if currentHealth < 1:
		get_tree().reload_current_scene()
	else:
		isTakeDamage = true
		animations.play("hurt")
		await animations.animation_finished
		isTakeDamage = false


func _on_jab_attack_area_entered(area):
	if !area.is_in_group("hurtBox"): return
	#print("Ударилл")

func jump():
	isJumping = true
	animations.play("jump")
	await animations.animation_finished
	isJumping = false
	wait_next_jump()


func wait_next_jump():
	waitNextJump = true
	await get_tree().create_timer(waitNextJump).timeout
	waitNextJump = false


func _on_down_bounce_area_body_entered(body):
	#print(position.dot(body.position))
	pass
