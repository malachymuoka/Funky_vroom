extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# disappears and gives the player 10 chu_chings on contact 





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		GlobalScne.find_child("sound_effects").find_child("coin_pickup").play()
		GlobalStats.chu_ching +=4
		queue_free()
