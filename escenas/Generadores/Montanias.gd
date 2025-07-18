extends Object
class_name Montanias

var tilemap : TileMapLayer
var noise : FastNoiseLite
var mountain_noise : FastNoiseLite
const TIERRA_TILE = Vector2i(2, 0)
const PASTO_TILE = Vector2i(3, 0)
const AGUA_TILE = Vector2i(14, 0)

var montania_tiles := {}

func setup(tmap, n, m_n):
	tilemap = tmap
	noise = n
	mountain_noise = m_n
	montania_tiles = {}

func generar(chunk_pos: Vector2i, chunk_size: int):
	var spacing = randi_range(5, 20)
	var offset = randi_range(0, spacing - 1)
	var start_x = chunk_pos.x * chunk_size

	for x in range(start_x, start_x + chunk_size):
		var terrain_height = 5 + noise.get_noise_2d(x, 0) * 5
		var mountain_value = mountain_noise.get_noise_2d(x, 0)

		if abs(x) > 10 and mountain_value > 0.6 and x % spacing == offset:
			var h = int(remap(mountain_value, 0.6, 1.0, 6, 20))
			var top = terrain_height - h
			for i in range(h):
				var width = h - i
				for j in range(-width, width + 1):
					var pos = Vector2i(x + j, terrain_height - i)
					var current_tile = tilemap.get_cell_atlas_coords(pos)
					if current_tile != AGUA_TILE:
						tilemap.set_cell(pos, 0, TIERRA_TILE)
						montania_tiles[pos] = true

			var top_pos = Vector2i(x, top)
			tilemap.set_cell(top_pos, 0, PASTO_TILE)
			montania_tiles[top_pos] = true

func es_montania(pos: Vector2i) -> bool:
	return montania_tiles.has(pos)
