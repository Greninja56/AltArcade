extends StaticBody2D

@export var speed := 500.0
var input_axis := 0.0

func _physics_process(delta):
	var h = get_viewport_rect().size.y
	if PhoneInput.connected:
		position.y = h / 2 + PhoneInput.pos * (h / 2 - 50)
	else:
		input_axis = Input.get_axis("move_up", "move_down")
		position.y += input_axis * speed * delta
	position.y = clamp(position.y, 50, h - 50)
