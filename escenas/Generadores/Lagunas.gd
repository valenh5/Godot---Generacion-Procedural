extends Object
class_name Lagunas

var tilemap : TileMapLayer
var noise : FastNoiseLite
const TIERRA_TILE = Vector2i(2, 0)
const AGUA_TILE = Vector2i(14, 0)

func setup(tmap, n):
	tilemap = tmap
	noise = n

func should_generate(chunk_pos: Vector2i) -> bool:
	var value = noise.get_noise_2d(chunk_pos.x, chunk_pos.y)
	return value < -0.3  

func generar(chunk_pos: Vector2i, chunk_size: int):
	var start_x = chunk_pos.x * chunk_size

	for x in range(start_x, start_x + chunk_size):
		var terrain_height = 5 + int(noise.get_noise_2d(x, 0) * 5)
		var lagoon_value = noise.get_noise_2d(x, 1000)

		if lagoon_value < -0.4 and abs(x) > 10 and x % 8 == 0:
			var radius = int(remap(lagoon_value, -1.0, -0.4, 3, 6))
			for dx in range(-radius, radius + 1):
				for dy in range(-radius, radius + 1):
					var dist = Vector2(dx, dy).length()
					var pos = Vector2i(x + dx, terrain_height + dy)

					var existing = tilemap.get_cell_atlas_coords(pos)

					if dist < radius - 1:
						if existing == null:
							tilemap.set_cell(pos, 0, AGUA_TILE)
					elif dist < radius:
						if existing == null:
							tilemap.set_cell(pos, 0, TIERRA_TILE)
