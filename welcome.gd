extends Area2D
var trig = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if trig <= 0: 
		trig+= 1
		print("welcome to roadborhood") # Replace with function body.
		

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if trig <= 1:
		print("good luvk :3") # Replace with function body.
		trig+= 1
