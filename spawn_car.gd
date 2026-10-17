extends Node2D
var car_scene: PackedScene = preload("res://its_vroom_vroom_time.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var car = car_scene.instantiate()
	
	add_child(car)
