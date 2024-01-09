extends Node2D

signal start_fight

@export var player: Player
@export var boss: Bobik
@export var trigger: Area2D
@export var isEnabled: bool = true
@export var DisableForwardBlock: bool = false
@export var DisableButtomBlock: bool = false
@onready var ForwardCollider = $BackForwardBlock/ForwardCollider
@onready var ButtomCollider = $BackForwardBlock/ButtomCollider

var isWaveStart: bool = false

func _ready():
	ForwardCollider.disabled = DisableForwardBlock
	ButtomCollider.disabled = DisableButtomBlock

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_area_body_entered(body):
	if !isEnabled: return
	if !body.is_in_group("player"): return 
	await get_tree().create_timer(6).timeout
	start_fight.emit()
	isWaveStart = true
	pass


func _on_level_area_area_entered(area):
	#if !isEnabled: return
	#if !area.is_in_group("player"): return 
	#await get_tree().create_timer(6).timeout
	#start_fight.emit()
	#isWaveStart = true
	pass
