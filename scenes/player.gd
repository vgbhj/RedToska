extends CharacterBody2D

@export var speed: int = 350
@onready var animations = $AnimatedSprite2D/AnimationPlayer
@onready var collider = $CollisionShape2D
var lastAnimDirection: String = "Right"

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
		pass
		
	velocity = velocity.normalized() * speed
	print(velocity)

func updateAnimation():
	var direction = "Right"
	if velocity == Vector2.ZERO:
		animations.play("idle")
		collider.position.x = $AnimatedSprite2D.position.x - 10
	else:
		animations.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	collider.position.x = $AnimatedSprite2D.position.x
	
	lastAnimDirection = direction

func _physics_process(delta):
	get_input()
	move_and_slide()
	updateAnimation()


func _on_jab_attack_area_entered(area):
	if area.is_in.group("hurtbox"):
		area.take_damage()
