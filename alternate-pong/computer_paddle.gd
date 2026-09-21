extends StaticBody2D

@export var ball: CharacterBody2D
@export var speed := 350.0
@export var miss_chance := 0.25
var miss_offset := 0.0
var ball_was_coming := false

func _ready():
	ball.served.connect(_on_ball_served)

func _on_ball_served():
	ball_was_coming = false 

func _physics_process(delta):
	var coming = ball.direction.x > 0
	if coming and not ball_was_coming:
		miss_offset = randf_range(80, 160) * [-1, 1].pick_random() if randf() < miss_chance else 0.0
	ball_was_coming = coming

	var target_y = ball.position.y + miss_offset if coming else get_viewport_rect().size.y / 2
	position.y = move_toward(position.y, target_y, speed * delta)
	position.y = clamp(position.y, 50, get_viewport_rect().size.y - 50)
