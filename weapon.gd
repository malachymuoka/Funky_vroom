extends Node2D

var damage 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#deletes itself
func _on_timer_timeout() -> void:
	queue_free()  # Replace with function body.



	


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	area.get_parent().health -= damage
		
