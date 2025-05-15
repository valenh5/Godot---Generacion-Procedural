extends TileMapLayer

var chunk_size : int = 20
var chunk_cant : int = 2
@export var noiseTexture : NoiseTexture2D
@onready var noise : FastNoiseLite = noiseTexture.noise

var chunk_status : Dictionary = {}
var chunk_data : Dictionary = {}

var tree_offset = randi_range(0, 8)
var next_tree = tree_offset

const TRONCO_TILE = Vector2i(4, 1)  
const HOJAS_TILE = Vector2i(2, 9)  
const TRONCO_ALTURA = 4 
const PASTO_TILE = Vector2i(3, 0)  
const TIERRA_TILE = Vector2i(2, 0) 
const AGUA_TILE = Vector2i(13, 12)
const HIERBA_TILE = Vector2i(12, 5)


func _ready():
	generateWorld(Vector2(0, 0))

func updateChunk(chunk_pos):
	for x in range(-chunk_cant, chunk_cant):
		for y in range(-chunk_cant, chunk_cant):
			var current_pos = chunk_pos + Vector2(x, y)
			
			if chunk_status.get(current_pos, false) != true:
				loadChunk(current_pos)
				
	for current_pos in chunk_status.keys() :
		if chunk_status[current_pos] == true and current_pos.distance_to(chunk_pos) > chunk_cant:
			unloadChunk(current_pos)


func saveChunks(chunk_pos):
	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size
	var chunk_tiles = []
	
	for x in range(start_x, start_x + chunk_size) :
		for y in range(start_y, start_y + chunk_size):
			var cell = get_cell_atlas_coords(Vector2(x, y))
			if cell != null:
				chunk_tiles.append({"pos" : Vector2(x, y), "tile" : cell})
	chunk_data[chunk_pos] = chunk_tiles

func loadChunk(chunk_pos):
	if chunk_status.get(chunk_pos, false) == true:
		return
	if chunk_pos in chunk_data:
		for tile in chunk_data[chunk_pos]:
			set_cell(tile["pos"], 0, tile["tile"])
	else:
		generateWorld(chunk_pos)
	chunk_status[chunk_pos] = true

func unloadChunk(chunk_pos) :
	if chunk_status.get(chunk_pos, false) == true:
		return
	saveChunks(chunk_pos)
	
	var start_x = chunk_pos.x * chunk_size
	var start_y = chunk_pos.y * chunk_size
	
	for x in range(start_x, start_x + chunk_size) :
		for y in range(start_y, start_y + chunk_size):
			erase_cell(Vector2i(x, y))
	chunk_status[chunk_pos] = false





func generateWorld(chunk_pos : Vector2):
	var start_x = chunk_pos.x * chunk_size
	var base_height = 10  

	for x in range(start_x, start_x + chunk_size):
		var height_variation = noise.get_noise_2d(x, 0) * 5
		var terrain_height = base_height + height_variation


		set_cell(Vector2(x, terrain_height), 0, PASTO_TILE)


		for y in range(terrain_height + 1, terrain_height + chunk_size):  
			set_cell(Vector2(x, y), 0, TIERRA_TILE)

		
		if x == next_tree:
			next_tree += randi_range(5, 15)
			var tree_top = terrain_height - TRONCO_ALTURA


			for i in range(TRONCO_ALTURA):
				set_cell(Vector2(x, terrain_height - i), 0, TRONCO_TILE)

			var leaf_positions = [
				Vector2(x, tree_top - 1),  
				Vector2(x - 1, tree_top - 1), 
				Vector2(x + 1, tree_top - 1),  
				Vector2(x - 1, tree_top),  
				Vector2(x + 1, tree_top),  
				Vector2(x, tree_top)  
			]

			for leaf_pos in leaf_positions:
				set_cell(leaf_pos, 0, HOJAS_TILE)
