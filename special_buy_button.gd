extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Dramatic_intro()

# Will slowly appear while in BUY_PARRY
func Dramatic_intro()->void:
	if visible == true:
		modulate.a +=0.01
	else:
		modulate.a = 0
