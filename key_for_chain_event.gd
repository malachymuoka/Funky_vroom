extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#If the player is near, they automatically collects the 
#key for the chain event 


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		GlobalStats.key_for_chain_event = true
		queue_free()
