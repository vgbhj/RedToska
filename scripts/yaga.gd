extends Node2D

@onready var audio = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_butilka_hit_box_area_entered(area):
	if area.is_in_group("hurtBoxPlayer"):
		audio.play()
		$Sprite2D.visible = false
		await get_tree().create_timer(1).timeout 
		queue_free()
