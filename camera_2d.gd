extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flexible_lim()



# Alters limits depending on what scene it is in
#(mostly just for he PARRY scene for now)

func flexible_lim()-> void:
	if get_tree().current_scene.name == "PARRY":
		
		limit_right = 290
		limit_bottom = 648
	else :
		limit_right = 385
		limit_bottom = 648
		
