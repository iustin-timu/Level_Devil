extends CharacterBody2D

const SPEED := 250.0
const JUMP_FORCE := -600.0
const GRAVITY := 1600.0

var start_position: Vector2

func _ready() -> void:
	# salvăm poziția de start și ne asigurăm că nu are viteză inițială
	start_position = global_position
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Gravitație doar pe Y (în jos)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# dacă e pe podea, nu mai continuă să "alunece" pe verticală
		velocity.y = 0.0

	# RESET la fiecare frame
	var direction := 0.0

	# input stânga/dreapta
	if Input.is_action_pressed("move_left"):
		direction -= 1.0
	if Input.is_action_pressed("move_right"):
		direction += 1.0

	velocity.x = direction * SPEED

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	move_and_slide()

	# dacă a căzut foarte jos, respawn la start
	if global_position.y > 1000.0:
		global_position = start_position
		velocity = Vector2.ZERO
