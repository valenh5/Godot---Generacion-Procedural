# Script del jugador
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var tilemap = $"../world"

@onready var chunkPos = Vector2(position.x / (tilemap.chunk_size * 20), position.y / (tilemap.chunk_size * 20))
@onready var prevchunkPos = chunkPos

func _physics_process(delta: float) -> void:
	chunkPos = Vector2(position.x / (tilemap.chunk_size * 20), position.y / (tilemap.chunk_size * 20))

	if prevchunkPos != chunkPos:
		tilemap.updateChunk(chunkPos)
		prevchunkPos = chunkPos

	# Aplicar gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Manejo de salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Manejo de movimiento
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
