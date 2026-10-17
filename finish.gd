extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# will congradulate the player for completing a lap

func _on_body_entered(body: Node2D) -> void:
	
	print("YOU DID IT :D") # Replace with function body.
	print("lap: "+ str(GlobalStats.difficulty_ramp))
	
