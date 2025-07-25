extends Node2D
class_name Chunk

@onready var tilemap = $TileMapLayer

@export var chunk_pos: Vector2i
@export var chunk_size: int = 16
@export var noiseTexture: NoiseTexture2D
@export var mountain_noise: FastNoiseLite
@export var agua_noise: FastNoiseLite

var noise: FastNoiseLite
var piso := Piso.new()
var arboles := Arboles.new()
var montanias := Montanias.new()
var lagunas := Lagunas.new()

func _ready(): 
	noise = noiseTexture.noise

	piso.setup(tilemap, noise)
	montanias.setup(tilemap, noise, mountain_noise)
	lagunas.setup(tilemap, agua_noise)
	arboles.setup(tilemap, noise, montanias)

	piso.generar(chunk_pos, chunk_size)

	if lagunas.should_generate(chunk_pos):
		lagunas.generar(chunk_pos, chunk_size)

	montanias.generar(chunk_pos, chunk_size)
	arboles.generar(chunk_pos, chunk_size)
