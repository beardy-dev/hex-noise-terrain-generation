extends Node2D

@onready var terrainMapLayer : TileMapLayer = $TileMapLayer
var perlinScale: float = 0.05
var worleyScale: float = 0.05
var islandCondition: float = 0.5
var coastCondition: float = 0.5
var worldSeed : int = randi()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateTileMap()
			
func generateTileMap() -> void:
	var grid: Vector2i = calcGridSize()
		
	for x in range(-1, grid.x):
		for y in range(-1, grid.y):
			placeTile(x,y)
	

func placeTile(x: int, y: int) -> void:
	var worleyVal = worley(float(x) * worleyScale, float(y) * worleyScale) / 1.414
	var perlinVal = (perlin(float(x + worldSeed * 1000) * perlinScale, float(y + worldSeed * 1000) * perlinScale) + 1) * 0.5
	
	var islandStrength = clamp(1.0 - (worleyVal / islandCondition), 0.0, 1.0)
	var coastNoise = perlinVal * islandStrength
	
	var tileId = 1 if coastNoise < coastCondition else 0
	
	terrainMapLayer.set_cell(Vector2(x,y), 0, Vector2(tileId, 0))

func generateNoiseVal(x: int, y: int) -> float:
	#return (perlin(float(x) * perlinScale, float(y) * perlinScale) + 1)  * 0.5
	return worley(x * worleyScale, y * worleyScale)

func calcGridSize() -> Vector2i:
	var windowSize: Vector2i = get_window().size
	var tileSize: Vector2i = terrainMapLayer.tile_set.tile_size
	
	var gridWidth = ceil((windowSize.x / tileSize.x) + 1)
	var gridHeight = ceil(windowSize.y / (tileSize.y * 0.75)) + 1
	return Vector2(gridWidth, gridHeight)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func perlin(x : float, y : float) -> float:
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
	var h = int(ix) * 1836311903 + worldSeed ^ int(iy) * 2971215073 + worldSeed
	h = (h << 13) ^ h
	var angle := float((h * (h * h * 15731 + 789221) + 1376312589) & 0x7fffffff) / 2147483648.0
	angle *= TAU
	return Vector2(cos(angle), sin(angle))
	
func fade(t):
	return 6 * pow(t,5) - 15 * pow(t, 4) + 10 * pow(t, 3)

func hash2(ix: int, iy: int) -> float:
	var h := ix * 374761393 + worldSeed + iy * 668265263 + worldSeed
	h = (h ^ (h >> 13)) * 1274126177
	h = h ^ (h >> 16)
	return float(h & 0x7fffffff) / 2147483648.0
	
func feature_point(ix: int, iy: int) -> Vector2:
	var rx = hash2(ix, iy)
	var ry = hash2(ix + 19, iy + 47)
	return Vector2(ix + rx, iy + ry)

func worley(x: float, y: float) -> float:
	var cx := int(floor(x))
	var cy := int(floor(y))

	var min_dist := INF

	for ox in range(-1, 2):
		for oy in range(-1, 2):
			var fp := feature_point(cx + ox, cy + oy)
			var d := Vector2(x, y).distance_to(fp)
			min_dist = min(min_dist, d)

	return min_dist
