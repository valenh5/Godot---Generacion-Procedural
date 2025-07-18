extends Object
class_name Arboles

var tilemap : TileMapLayer
var noise : FastNoiseLite
var montanias_ref
const TRONCO_TILE = Vector2i(4, 1)
const HOJAS_TILE = Vector2i(2, 9)
const TRONCO_ALTURA = 4

func setup(tmap, n, montanias_obj):
	tilemap = tmap
	noise = n
	montanias_ref = montanias_obj

func generar(chunk_pos: Vector2i, chunk_size: int):
	var tree_rango = obtener_rango(Global.arbol)
	var spacing = randi_range(tree_rango.x, tree_rango.y)
	var offset = randi_range(0, spacing - 1)
	var start_x = chunk_pos.x * chunk_size

	for x in range(start_x, start_x + chunk_size):
		var height = 5 + noise.get_noise_2d(x, 0) * 5
		if abs(x) > 10 and x % spacing == offset:
			var puede_colocar := true


			for i in range(TRONCO_ALTURA):
				var tronco_pos = Vector2i(x, int(height) - i)
				if montanias_ref.es_montania(tronco_pos):
					puede_colocar = false
					break


			if puede_colocar:
				for i in range(-1, 2):
					for j in range(-1, 2):
						var hoja_pos = Vector2i(x + i, int(height) - TRONCO_ALTURA + j)
						if montanias_ref.es_montania(hoja_pos):
							puede_colocar = false
							break


			if puede_colocar:
				colocar_arbol(x, int(height))

func colocar_arbol(x: int, y: int):
	for i in range(TRONCO_ALTURA):
		tilemap.set_cell(Vector2i(x, y - i), 0, TRONCO_TILE)
	for i in range(-1, 2):
		for j in range(-1, 2):
			tilemap.set_cell(Vector2i(x + i, y - TRONCO_ALTURA + j), 0, HOJAS_TILE)

func obtener_rango(valor: int) -> Vector2i:
	match valor:
		3: return Vector2i(3, 8)
		2: return Vector2i(8, 15)
		1: return Vector2i(15, 35)
		_: return Vector2i(8, 15)
