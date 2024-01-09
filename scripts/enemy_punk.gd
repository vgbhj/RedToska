extends CharacterBody2D

signal enemy_death

@export var speed = 200
@export var distanceBetweenPlayer = 100
@export var attack_interval = 2
@onready var player = get_tree().root.get_child(0).get_child(0).get_node("Player")
@onready var animations = $AnimatedSprite2D/AnimationEnemy
@onready var collider = $Collider
@onready var jabAttackCollider = $AnimatedSprite2D/JabAttack/JabAttackCollider

@onready var audio = $hitSFX
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
	
	collider.position.x = $AnimatedSprite2D.position.x

func move_to_player():
	velocity = Vector2.ZERO
	if global_position.distance_to(player.get_child(0).get_child(0).global_position) > distanceBetweenPlayer:
		velocity = global_position.direction_to(player.get_child(0).get_child(0).global_position) * speed

func _ready():
	pass

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
	if currentHealth < 1:
		isDead = true
		enemy_death.emit()
		audio.play()
		animations.play("death")
		await animations.animation_finished
		queue_free()
	else:
		isTakeDamage = true
		audio.play()
		animations.play("hurt")
		await animations.animation_finished
		isTakeDamage = false
