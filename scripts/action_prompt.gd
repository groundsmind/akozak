extends HBoxContainer

@onready var key: Label = $CenterContainer/Key
@onready var hint: Label = $Hint
@onready var progress_bar: TextureProgressBar = $CenterContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_progressbar()

func connect_action(action: InteractSource) -> void:
	key.text = OS.get_keycode_string(action.key)
	hint.text = action.hint
	progress_bar.max_value = action.duration
	

func update_progressbar() -> void:
	# make value go up with timer
	pass
