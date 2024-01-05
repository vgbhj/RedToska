extends CharacterBody2D

@export var speed = 300
var player_position
var target_position
@onready var player = get_parent().get_node("Player")
@onready var animations = $AnimatedSprite2D/AnimationEnemy
@onready var collider = $CollisionShape2D
@onready var jabAttackCollider = $AnimatedSprite2D/JabAttack/JabAttackCollider
var lastAnimDirection: String = "Left"
var isAttacking: bool = false

func attackPlayer():
	pass

func updateAnimation():
	if isAttacking:
		return
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
	
	collider.position.x = $AnimatedSprite2D.position.x

func move_to_player():
	velocity = position.direction_to(player.position) * speed

func _physics_process(delta):
	move_to_player()
	updateAnimation()
	move_and_slide()

func _on_jab_attack_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()


func _on_player_detecter_area_entered(area):
	print("HAHA AREA")
	if area.is_in_group("player"):
		print("HAHAHA")


func _on_player_detecter_body_entered(body):
	if body.is_in_group("player"):
		attackPlayer()
