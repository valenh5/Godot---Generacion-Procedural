extends Object
class_name Lagunas

var tilemap : TileMapLayer
var noise : FastNoiseLite
const TIERRA_TILE = Vector2i(2, 0)
const AGUA_TILE = Vector2i(14, 12)

func setup(tmap, n):
	tilemap = tmap
	noise = n

func should_generate(chunk_pos: Vector2i) -> bool:
	var value = noise.get_noise_2d(chunk_pos.x, chunk_pos.y)
	return value < -0.3

func generar(chunk_pos: Vector2i, chunk_size: int):
	var start_x = chunk_pos.x * chunk_size
	var lagoon_start = start_x + randi_range(2, chunk_size - 10)
	var lagoon_width = randi_range(6, 12)

	for x in range(lagoon_start, lagoon_start + lagoon_width):
		var terrain_height = 5 + int(noise.get_noise_2d(x, 0) * 5)
		var agua_pos = Vector2i(x, terrain_height)


		for y in range(terrain_height + 1, terrain_height + 4):
			var fill_pos = Vector2i(x, y)
			var fill_tile = tilemap.get_cell_atlas_coords(fill_pos)
			if fill_tile == Vector2i(-1, -1):
				tilemap.set_cell(fill_pos, 0, TIERRA_TILE)


		var existing = tilemap.get_cell_atlas_coords(agua_pos)
		if existing == Vector2i(-1, -1):
			tilemap.set_cell(agua_pos, 0, AGUA_TILE)
