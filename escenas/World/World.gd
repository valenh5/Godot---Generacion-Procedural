extends Node2D
class_name World

@export var chunk_scene: PackedScene
@export var chunk_size: int = 16
@export var chunk_cant: int = 2
@export var noise_texture: NoiseTexture2D
@onready var player = $Player

var noise: FastNoiseLite
var mountain_noise := FastNoiseLite.new()

var chunk_status: Dictionary = {}
var chunk_data: Dictionary = {}

func _ready():
	print("Montanias elegida:", Global.montania)
	print("Arbol elegido:", Global.arbol)

	noise = noise_texture.noise

	mountain_noise.seed = randi()
	mountain_noise.frequency = 0.05
	mountain_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	mountain_noise.fractal_octaves = 3

	var center = Vector2i(0, 0)
	generate_chunks(center)

	var player_x = 0
	var player_chunk_pos = get_chunk_pos_from_world_pos(Vector2(player_x, 0))
	var piso_y = get_piso_height(player_chunk_pos, player_x)

	player.global_position = Vector2(player_x, piso_y * 16 - player.get_node("Sprite2D").texture.get_height())

func get_chunk_pos_from_world_pos(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / float(chunk_size * 16)),
		floor(world_pos.y / float(chunk_size * 16))
	)

func get_piso_height(chunk_pos: Vector2i, x_world_pos: float) -> int:
	return 5 + int(noise.get_noise_2d(int(x_world_pos), 0) * 5)

func generate_chunks(center_chunk: Vector2i):
	for x in range(-chunk_cant, chunk_cant + 1):
		for y in range(-chunk_cant, chunk_cant + 1):
			var pos = center_chunk + Vector2i(x, y)
			if not chunk_status.has(pos):
				load_chunk(pos)

func load_chunk(pos: Vector2i):
	var chunk = chunk_scene.instantiate()
	chunk.chunk_pos = pos
	chunk.chunk_size = chunk_size
	chunk.noiseTexture = noise_texture
	chunk.mountain_noise = mountain_noise
	call_deferred("add_child", chunk)
	chunk_status[pos] = true
