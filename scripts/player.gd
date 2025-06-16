extends CharacterBody2D

@export var speed: float = 1000
@export var jump_velocity: float = -400.0

@onready var world = get_tree().get_first_node_in_group("world")

var current_chunk_pos: Vector2i

func _ready():
	update_chunk_position()

func _process(_delta):
	update_chunk_position()

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	velocity.x = direction.x * speed

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_velocity

	velocity.y += 900 * delta 

	move_and_slide()

func update_chunk_position():
	if world == null:
		push_warning("World no encontrado. Asegurate de que el nodo World esté en el grupo 'world'.")
		return

	var new_chunk_pos = world.get_chunk_pos_from_world_pos(global_position)
	if new_chunk_pos != current_chunk_pos:
		current_chunk_pos = new_chunk_pos
		print("Jugador entró en chunk:", current_chunk_pos)
		world.generate_chunks(current_chunk_pos) 
