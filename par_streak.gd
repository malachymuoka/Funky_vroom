extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible()


# Shows the player how many times they were able to parry in a row

func visible()-> void:
	if GlobalStats.CAN_PARRY == true && GlobalStats.par_streak >0:
		show()
		text = "STREAK: "+ str(GlobalStats.par_streak) + "!"
	else:
		hide()
