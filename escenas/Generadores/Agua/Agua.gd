extends Node2D
class_name Agua

@export var chunk_pos: Vector2i
@export var chunk_size: int = 16
@export var noise: FastNoiseLite

@onready var tilemap: TileMap = $TileMapAgua

const WATER_THRESHOLD := 0.4
const AGUA_TILE := Vector2i(14, 0)

func init():
	if noise == null:
		push_error("⚠️ AGUA: El ruido no fue asignado correctamente")
		return
	generate_agua()

func generate_agua():
	for x in chunk_size:
		var world_x = chunk_pos.x * chunk_size + x
		var piso_y = int((noise.get_noise_2d(world_x, 0)) * 5 + 5)  # misma fórmula que el terreno

		for y in chunk_size:
			var world_y = chunk_pos.y * chunk_size + y
			if world_y > piso_y:
				tilemap.set_cell(0, Vector2i(x, y), 0, AGUA_TILE)
