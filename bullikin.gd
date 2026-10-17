extends Area2D

var posx
var posy
var direction:Vector2
var speed = 100
var pierced:int = 0

var damage :int 
# Renames itself to bulletss 
func _ready() -> void:
	
	name = "bulletss"
	position = Vector2(posx,posy) + direction*20
	
	if direction == Vector2(1,0):
		rotation_degrees= 90
	elif direction == Vector2(-1,0):
		rotation_degrees-= 90
	elif direction == Vector2(0,-1):
		pass
	elif direction == Vector2(0,1):
		get_node("ded_bozo").flip_v = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	end()
	position += direction *speed*delta
	

func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(7) == true:
		area.get_parent().health -= damage
		queue_free()
		


func end()->void:
	if pierced== 3:
		queue_free()
