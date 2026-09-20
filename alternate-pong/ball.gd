extends CharacterBody2D

@export var start_speed := 400.0
@export var speed_up := 1.05
@export var max_speed := 1100.0
var speed := 0.0
var direction := Vector2.ZERO

signal served

func _ready():
	reset()

func reset(toward := 0):
	position = get_viewport_rect().size / 2
	speed = start_speed
	var x = toward if toward != 0 else [-1, 1].pick_random()
	direction = Vector2(x, randf_range(-0.5, 0.5)).normalized()
	served.emit()

func _physics_process(delta):
	var hit = move_and_collide(direction * speed * delta)
	if hit:
		direction = direction.bounce(hit.get_normal())
		if hit.get_collider().is_in_group("paddle"):
			speed = min(speed * speed_up, max_speed)
