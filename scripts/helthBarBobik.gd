extends TextureProgressBar

@export var bobik: Bobik

func _ready():
	bobik.healthChanged.connect(update)
	update(bobik.currentHealth)

func update(cur):
	#print(player.currentSuper)
	value = bobik.currentHealth * 100 / bobik.maxHealth
	if value == 0:
		queue_free()
