extends Object
class_name Agua

var tilemap : TileMapLayer
var noise : FastNoiseLite

const AGUA_TILE = Vector2i(14, 0)
const PROFUNDIDAD_MAX = 5

func setup(tmap, n):
	tilemap = tmap
	noise = n

func generar(chunk_pos: Vector2i, chunk_size: int):
	var agua_rango = obtener_rango(Global.agua) 
	var spacing = randi_range(agua_rango.x, agua_rango.y)
	var offset = randi_range(0, spacing - 1)
	var start_x = chunk_pos.x * chunk_size

	for x in range(start_x, start_x + chunk_size):
		var altura_terreno = int(5 + noise.get_noise_2d(x, 0) * 5)
		var nivel_agua = 8  # Altura base del agua

		if abs(x) > 10 and x % spacing == offset and altura_terreno < nivel_agua:
			var profundidad = nivel_agua - altura_terreno
			profundidad = clamp(profundidad, 1, PROFUNDIDAD_MAX)
			colocar_agua(x, altura_terreno, profundidad)

func colocar_agua(x: int, desde_y: int, profundidad: int):
	for i in range(profundidad):
		tilemap.set_cell(Vector2i(x, desde_y + i), 0, AGUA_TILE)

func obtener_rango(valor: int) -> Vector2i:
	match valor:
		3: return Vector2i(3, 6)
		2: return Vector2i(6, 12)
		1: return Vector2i(12, 20)
		_: return Vector2i(8, 15)
