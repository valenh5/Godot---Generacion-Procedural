extends TileMapLayer

var chunk_size : int = 16
var chunk_cant : int = 2

@export var noiseTexture : NoiseTexture2D
@onready var noise : FastNoiseLite = noiseTexture.noise
@onready var mountain_noise := FastNoiseLite.new()

var chunk_status : Dictionary = {}
var chunk_data : Dictionary = {}

const TRONCO_TILE = Vector2i(4, 1)  
const HOJAS_TILE = Vector2i(2, 9)  
const TRONCO_ALTURA = 4 
const PASTO_TILE = Vector2i(3, 0)  
const TIERRA_TILE = Vector2i(2, 0) 
const AGUA_TILE = Vector2i(13, 12)
const HIERBA_TILE = Vector2i(12, 5)

var tree_spacing : int
var tree_offset : int

var mountain_spacing : int
var mountain_offset : int

func _ready():
	print("Montanias elegida:", Global.montania)
	print("Arbol elegido:", Global.arbol)

	mountain_noise.seed = randi()
	mountain_noise.frequency = 0.05
	mountain_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	mountain_noise.fractal_octaves = 3

	var tree_rango = obtener_rango_desde_valor(Global.arbol)
	tree_spacing = randi_range(tree_rango.x, tree_rango.y)
	tree_offset = randi_range(0, tree_spacing - 1)

	var montania_rango = obtener_rango_desde_valor(Global.montania)
	mountain_spacing = randi_range(montania_rango.x, montania_rango.y)
	mountain_offset = randi_range(0, mountain_spacing - 1)

	generateWorld(Vector2i(0, 0))

func obtener_rango_desde_valor(valor: int) -> Vector2i:
	match valor:
		3:
			return Vector2i(3, 8)
		2:
			return Vector2i(8, 15)
		1:
			return Vector2i(15, 35)
		_:
			return Vector2i(8, 15) 

func updateChunk(chunk_pos):
	for x in range(-chunk_cant, chunk_cant):
		for y in range(-chunk_cant, chunk_cant):
			var current_pos = chunk_pos + Vector2i(x, y)
			if chunk_status.get(current_pos, false) != true:
				loadChunk(current_pos)
				
	for current_pos in chunk_status.keys():
		if chunk_status[current_pos] == true and current_pos.distance_to(chunk_pos) > chunk_cant:
			unloadChunk(current_pos)

func saveChunks(chunk_pos):
	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size
	var chunk_tiles = []
	for x in range(start_x, start_x + chunk_size):
		for y in range(start_y, start_y + chunk_size):
			var cell = get_cell_atlas_coords(Vector2i(x, y))
			if cell != null:
				chunk_tiles.append({"pos": Vector2i(x, y), "tile": cell})
	chunk_data[chunk_pos] = chunk_tiles

func loadChunk(chunk_pos):
	if chunk_status.get(chunk_pos, false) == true:
		return
	if chunk_pos in chunk_data:		for tile in chunk_data[chunk_pos]:
			set_cell(tile["pos"], 0, tile["tile"])
	else:
		generateWorld(chunk_pos)
	chunk_status[chunk_pos] = true

func unloadChunk(chunk_pos):
	if chunk_status.get(chunk_pos, false) == true:
		return
	saveChunks(chunk_pos)
	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size
	for x in range(start_x, start_x + chunk_size):
		for y in range(start_y, start_y + chunk_size):
			erase_cell(Vector2i(x, y))
	chunk_status[chunk_pos] = false

func colocar_arbol(pos_x: int, pos_y: int):
	for i in range(TRONCO_ALTURA):
		set_cell(Vector2i(pos_x, pos_y - i), 0, TRONCO_TILE)
	for i in range(-1, 2):
		for j in range(-1, 2):
			set_cell(Vector2i(pos_x + i, pos_y - TRONCO_ALTURA + j), 0, HOJAS_TILE)

func generateWorld(chunk_pos : Vector2i):
	
	var start_x = chunk_pos.x * chunk_size
	var base_height = 5
	var protected_range = 10

	for x in range(start_x, start_x + chunk_size):
		var height_variation = noise.get_noise_2d(x, 0) * 5
		var terrain_height = base_height + height_variation
		var terrain_pos = Vector2i(x, terrain_height)

		set_cell(terrain_pos, 0, PASTO_TILE)
		for y in range(terrain_height + 1, terrain_height + chunk_size):
			set_cell(Vector2i(x, y), 0, TIERRA_TILE)

		var mountain_value = mountain_noise.get_noise_2d(x, 0)
		if abs(x) > protected_range and mountain_value > 0.6 and x % mountain_spacing == mountain_offset:
			var mountain_height = int(remap(mountain_value, 0.6, 1.0, 6, 20))
			var mountain_top = terrain_height - mountain_height
			for i in range(mountain_height):
				var width = mountain_height - i
				for j in range(-width, width + 1):    
					set_cell(Vector2i(x + j, terrain_height - i), 0, TIERRA_TILE)
			set_cell(Vector2i(x, mountain_top), 0, PASTO_TILE)
			continue

		if abs(x) > protected_range and x % tree_spacing == tree_offset:
			colocar_arbol(x, int(terrain_height))
