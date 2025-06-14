extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var tilemap = $"../world"

@onready var chunkPos = Vector2i(position.x / (tilemap.chunk_size * 16), position.y / (tilemap.chunk_size * 16))
@onready var prevchunkPos = chunkPos

func _physics_process(delta: float) -> void:
	chunkPos = Vector2i(position.x / (tilemap.chunk_size * 16), position.y / (tilemap.chunk_size * 16))

	if prevchunkPos != chunkPos:
		tilemap.updateChunk(chunkPos)
		prevchunkPos = chunkPos

	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
