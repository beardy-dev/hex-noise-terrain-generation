extends Node2D

@onready var terrainMapLayer = $TileMapLayer
var perlinScale: float = 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grid: Vector2i = calcGridSize()
		
	for x in range(-1, grid.x):
		for y in range(-1, grid.y):
			var rawPerlin = perlin(x*perlinScale, y*perlinScale)
			var normalizedPerlin = (rawPerlin + 1) * 0.5
			var tileId = 0 if normalizedPerlin < 0.5 else 1
			terrainMapLayer.set_cell(Vector2(x, y), 0, Vector2(tileId, 0))


func calcGridSize() -> Vector2i:
	var windowSize: Vector2i = get_window().size
	var tileSize: Vector2i = terrainMapLayer.tile_set.tile_size
	
	var gridWidth = ceil((windowSize.x / tileSize.x) + 1)
	var gridHeight = ceil(windowSize.y / (tileSize.y * 0.75)) + 1
	return Vector2(gridWidth, gridHeight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func perlin(x, y) -> float:
	var x0 = floor(x)
	var y0 = floor(y)
	var x1 = x0 + 1
	var y1 = y0 + 1
	
	var g00 = gradient(x0, y0)
	var g01 = gradient(x1, y0)
	var g10 = gradient(x0, y1)
	var g11 = gradient(x1, y1)
	
	var d00 = Vector2(x - x0, y - y0)
	var d01 = Vector2(x - x1, y - y0)
	var d10 = Vector2(x - x0, y - y1)
	var d11 = Vector2(x - x1, y - y1)
	
	var n00 = g00.dot(d00)
	var n01 = g01.dot(d01)
	var n10 = g10.dot(d10)
	var n11 = g11.dot(d11)
	
	var u = fade(x - x0)
	var v = fade(y - y0)
	
	var nx0 = lerp(n00, n10, u)
	var nx1 = lerp(n01, n11, u)
	
	return lerp(nx0, nx1, v)
		
func gradient(ix, iy) -> Vector2:
	var hash = randf_range(ix, iy)
	var angle = hash * (PI * 2)
	return Vector2(cos(angle), sin(angle))
	
func fade(t):
	return pow(6*t,5) - pow(15 * t, 4) + pow(10 * t, 3)
