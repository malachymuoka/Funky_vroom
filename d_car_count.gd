extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	display()
	
# displays the number of carbinjors heads you have

func display()-> void:
	if GlobalStats.carbinjor_heads >=1:
		show()
		$d_Car_count.text = ":"+str(GlobalStats.carbinjor_heads)
	else:
		hide()
