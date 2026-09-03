extends OptionButton

#  resolutions.
const RESOLUTIONS = {
	"1920 x 1080": Vector2i(1920, 1080),
	"1280 x 720": Vector2i(1280, 720),
	"854 x 480": Vector2i(854, 480)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for res_text in RESOLUTIONS.keys():
		add_item(res_text)
		
	item_selected.connect(_on_resolution_selected)

func _on_resolution_selected(index: int) -> void:
	var res_text = get_item_text(index)
	var target_size = RESOLUTIONS[res_text]
	
	# Change the current window size
	Globals.settingsMenu.resolutionValue = target_size
