extends Node2D
class_name Chunk

@onready var tilemap = $TileMapLayer

@export var chunk_pos: Vector2i
@export var chunk_size: int = 16
@export var noiseTexture: NoiseTexture2D
@export var mountain_noise: FastNoiseLite

var noise: FastNoiseLite
var piso := Piso.new()
var arboles := Arboles.new()
var montanias := Montanias.new()

func _ready(): 
	noise = noiseTexture.noise

	piso.setup(tilemap, noise)
	arboles.setup(tilemap, noise)
	montanias.setup(tilemap, noise, mountain_noise)

	piso.generar(chunk_pos, chunk_size)
	arboles.generar(chunk_pos, chunk_size)
	montanias.generar(chunk_pos, chunk_size)
