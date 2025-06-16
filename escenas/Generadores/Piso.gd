extends Object
class_name Piso

var tilemap : TileMapLayer
var noise : FastNoiseLite
const PASTO_TILE = Vector2i(3, 0)
const TIERRA_TILE = Vector2i(2, 0)

func setup(tmap: TileMapLayer, n: FastNoiseLite) -> void:
	tilemap = tmap
	noise = n

func generar(chunk_pos: Vector2i, chunk_size: int) -> void:
	var start_x = chunk_pos.x * chunk_size
	for x in range(start_x, start_x + chunk_size):
		var height = 5 + noise.get_noise_2d(x, 0) * 5
		tilemap.set_cell(Vector2i(x, height), 0, PASTO_TILE)
		for y in range(height + 1, height + chunk_size):
			tilemap.set_cell(Vector2i(x, y), 0, TIERRA_TILE)
