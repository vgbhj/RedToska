extends CharacterBody2D

@export var speed: int = 350
@onready var animations = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed

func updateAnimation():
	var direction = "Right"
	if velocity == Vector2.ZERO:
		animations.play("idle")
		collider.position.x = animations.position.x - 10
	else:
		animations.play("walk")
		animations.flip_h = velocity.x < 0
	
	collider.position.x = animations.position.x

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()
