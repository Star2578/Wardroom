extends TextureRect

var time := 0.0
var fade_duration := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	if time < fade_duration:
		modulate.a = time / fade_duration
	else:
		modulate.a = 1.0
		
