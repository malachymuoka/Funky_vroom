extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_collect_da_key_body_entered(body: Node2D) -> void:
	if body.name == "player":
		GlobalStats.Da_angel_key = true
		queue_free()
