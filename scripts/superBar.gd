extends TextureProgressBar

@export var player: Player

func _ready():
	player.superChanged.connect(update)
	update(player.currentSuper)

func update(cur):
	print(player.currentSuper)
	value = player.currentSuper * 100 / player.maxSuper
