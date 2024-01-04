extends CharacterBody2D

@export var speed: int = 350
@onready var animations = $AnimatedSprite2D/AnimationPlayer
@onready var collider = $CollisionShape2D
var lastAnimDirection: String = "Right"

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed
	
	if Input.is_action_just_pressed("jab_attack"):
		pass

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
	handleInput()
	move_and_slide()
	updateAnimation()


func _on_jab_attack_area_entered(area):
	if area.is_in.group("hurtbox"):
		area.take_damage()
