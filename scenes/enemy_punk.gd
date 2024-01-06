extends CharacterBody2D

signal enemy_death

@export var speed = 300
@export var distanceBetweenPlayer = 100
@onready var player = get_tree().root.get_child(0).get_node("Player")
@onready var animations = $AnimatedSprite2D/AnimationEnemy
@onready var collider = $Collider
@onready var jabAttackCollider = $AnimatedSprite2D/JabAttack/JabAttackCollider

@export var maxHealth = 5
@onready var currentHealth: int = maxHealth

var lastAnimDirection: String = "Left"
var isDead: bool = false
var isTakeDamage: bool = false
var inAttackZone: bool = false
var isAttacking: bool = false

func updateAnimation():
	if inAttackZone:
		if lastAnimDirection == "Right":
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x - 40
		else:
			jabAttackCollider.position.x = $AnimatedSprite2D.position.x + 10 
		
		animations.play("jab_attack")
		isAttacking = true
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
	
	collider.position.x = $AnimatedSprite2D.position.x

func move_to_player():
	velocity = Vector2.ZERO
	if global_position.distance_to(player.global_position) > distanceBetweenPlayer:
		velocity = global_position.direction_to(player.global_position) * speed


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
