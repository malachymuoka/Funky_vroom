extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# if the player has the key for it, then it will set
#GlobalStats.key_for_chain_event to false and
#Go away

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" && GlobalStats.key_for_chain_event == true:
		GlobalStats.key_for_chain_event = false
		queue_free()
