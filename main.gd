extends Node

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_ui_perlin_scale_change(value : float) -> void:
	$HexGrid.perlinScale = value
	clearAndRegenTileMap()


func _on_ui_island_condition_changed(value : float) -> void:
	$HexGrid.islandCondition = value
	clearAndRegenTileMap()
	
func _on_ui_coast_condition_changed(value : float) -> void:
	$HexGrid.coastCondition = value
	clearAndRegenTileMap()


func _on_ui_worley_scale_change(value : float) -> void:
	$HexGrid.worleyScale = value
	clearAndRegenTileMap()
	

func clearAndRegenTileMap() -> void:
	$HexGrid/TileMapLayer.clear()
	$HexGrid.generateTileMap()
