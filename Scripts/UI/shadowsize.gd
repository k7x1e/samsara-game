extends OptionButton

#  resolutions.
const RESOLUTIONS = {
	"4096": int(4096),
	"2048": int(2048),
	"1024": int(1024),
	"512": int(512),
	"256": int(256),
	"128": int(128)
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
	Globals.settingsMenu.shadowValue = target_size
