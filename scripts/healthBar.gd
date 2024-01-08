extends TextureProgressBar

@export var player: Player

func _ready():
	player.healthChanged.connect(update)
	update(player.currentHealth)

func update(cur):
	print(player.currentHealth)
	value = player.currentHealth * 100 / player.maxHealth
