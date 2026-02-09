extends CanvasLayer

signal perlinScaleChange
signal islandConditionChanged
signal worleyScaleChange
signal coastConditionChanged

# Perlin Scale Input Controls
@onready var perlinScaleSlider : HSlider = $PanelContainer/Controls/PerlinScaleBox/PerlinScaleInputSlider
@onready var perlinScaleLabel : Label = $PanelContainer/Controls/PerlinScaleBox/HBoxContainer/PerlinScaleValueLabel

# Worley Scale Input Controls
@onready var worleyScaleSlider : HSlider = $PanelContainer/Controls/WorleyScaleBox/WorleyScaleInputSlider
@onready var worleyScaleLabel : Label = $PanelContainer/Controls/WorleyScaleBox/HBoxContainer/WorleyScaleValueLabel

# Sample Noise Condition Input Controls
@onready var islandConditionSlider : HSlider = $PanelContainer/Controls/IslandConditionBox/IslandConditionInputSlider
@onready var islandConditionLabel : Label = $PanelContainer/Controls/IslandConditionBox/HBoxContainer/IslandConditionValueLabel

@onready var coastConditionSlider : HSlider = $PanelContainer/Controls/CoastConditionBox/CoastConditionInputSlider
@onready var coastConditionLabel : Label = $PanelContainer/Controls/CoastConditionBox/HBoxContainer/CoastConditionValueLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worleyScaleLabel.text = str(worleyScaleSlider.value)
	perlinScaleLabel.text = str(perlinScaleSlider.value)
	islandConditionLabel.text = str(islandConditionSlider.value)
	coastConditionLabel.text = str(coastConditionSlider.value)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func perlinScaleValueChange(value : float) -> void:
	perlinScaleLabel.text = str(value)
	perlinScaleChange.emit(value)
	
func worleyScaleValueChange(value : float) -> void:
	worleyScaleLabel.text = str(value)
	worleyScaleChange.emit(value)
	
func IslandConditionValueChange(value : float) -> void:
	islandConditionLabel.text = str(value)
	islandConditionChanged.emit(value)


func coastConditionValueChange(value: float) -> void:
	coastConditionLabel.text = str(value)
	coastConditionChanged.emit(value)
