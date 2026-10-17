extends Node2D
var bullets = preload("res://bullets.tscn").instantiate()
var direction_gun: Vector2 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	var blet = bullets
	blet.direction = direction_gun 
	blet.posx = global_position.x 
	blet.posy = global_position.y 
	blet.damage = 20 * (1 + 0.1 *(GlobalStats.STR))
	get_tree().current_scene.add_child(blet) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.
