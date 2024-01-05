extends CharacterBody2D

@export var speed: int = 350
@onready var animations = $AnimatedSprite2D/AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var jabAttackCollider = $AnimatedSprite2D/JabAttack/JabAttackCollider
var lastAnimDirection: String = "Left"
var isAttacking: bool = false
@onready var camera = $Camera2D

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if Input.is_action_just_pressed("jab_attack"):
		if lastAnimDirection == "Right":
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x - 40
		else:
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x + 10 
		
		animations.play("jab_attack")
		isAttacking = true
		await animations.animation_finished
		isAttacking = false
		
	velocity = velocity.normalized() * speed

func updateAnimation():
	if isAttacking:
		return
	if velocity == Vector2.ZERO:
		animations.play("idle")
		collider.position.x = $AnimatedSprite2D.position.x - 10
	else:
		animations.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
		var direction = "Left"
		if velocity.x < 0:
			direction = "Right"
			
		lastAnimDirection = direction
	
	collider.position.x = $AnimatedSprite2D.position.x


func _physics_process(delta):
	get_input()
	move_and_slide()
	updateAnimation()


func _on_jab_attack_area_entered(area):
	print("HAHA JAB")
	if area.is_in_group("hitBox"):
		area.take_damage()
