extends CollisionShape2D

@onready var screen_size = get_tree().root.size
@onready var player = $"../../Ysort/Player"
var d
# Called when the node enters the scene tree for the first time.
func _ready():
	d = screen_size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(player.position.x - position.x) > d:
		position.x += abs(player.position.x - (position.x+d))