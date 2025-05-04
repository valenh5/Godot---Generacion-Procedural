extends TileMapLayer

var chunk_size : int = 20
var chunk_cant : int = 2
@export var noiseTexture : NoiseTexture2D
@onready var noise : FastNoiseLite = noiseTexture.noise

var TREE_SPACING = int(randi_range(8, 20)) 
const TRONCO_TILE = Vector2i(4, 1)  
const HOJAS_TILE = Vector2i(2, 9)  
const TRONCO_ALTURA = 4 

const PASTO_TILE = Vector2i(3, 0)  
const TIERRA_TILE = Vector2i(2, 0) 

const AGUA_TILE = Vector2i(13, 12)
func _ready():
	generateWorld(Vector2(0, 0))

func generateWorld(chunk_pos : Vector2):
	var start_x = chunk_pos.x * chunk_size
	var base_height = 10  

	for x in range(start_x, start_x + chunk_size):
		var height_variation = noise.get_noise_2d(x, 0) * 5
		var terrain_height = base_height + height_variation


		set_cell(Vector2(x, terrain_height), 0, PASTO_TILE)


		for y in range(terrain_height + 1, terrain_height + chunk_size):  
			set_cell(Vector2(x, y), 0, TIERRA_TILE)

		
		if x % TREE_SPACING == 0:
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
