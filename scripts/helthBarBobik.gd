extends TextureProgressBar

@export var bobik: Bobik

func _ready():
	bobik.healthChanged.connect(update)
	update(bobik.currentHealth)
	visible = false

func update(cur):
	#print(player.currentSuper)
	value = bobik.currentHealth * 100 / bobik.maxHealth
	if value == 0:
		queue_free()


func _on_boss_level_start_fight():
	visible = true
