extends Button

var time := 0.0
var speed := 2.0
var delay := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	if time < delay:
		modulate.a = 0
	else:
		var alpha = cos(time * speed) / 2.0
		modulate.a = alpha
