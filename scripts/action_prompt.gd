extends HBoxContainer

@onready var key_label: Label = $CenterContainer/KeyLabel
@onready var hint_label: Label = $HintLabel
@onready var progress_bar: TextureProgressBar = $CenterContainer/ProgressBar
var action: InteractSource
var curr_tween: Tween

func _ready() -> void:
	GlobalInteractData.interacting.connect(_bump)
	GlobalInteractData.interaction_over.connect(_bump_back)
	key_label.pivot_offset = key_label.size/2

func set_action(gid_action: InteractSource) -> void:
	action = gid_action
	key_label.text = OS.get_keycode_string(action.key)
	hint_label.text = action.hint
	progress_bar.max_value = action.duration

func _bump(curr_action) -> void:
	if OS.get_keycode_string(curr_action.key) == key_label.text:
		if curr_tween:
			curr_tween.kill()
		key_label.scale = Vector2(2.0, 0.5)
		key_label.rotation += randf_range(deg_to_rad(-45), deg_to_rad(45))

func _bump_back(curr_action) -> void:
	if OS.get_keycode_string(curr_action.key) == key_label.text:
		add_tween(key_label, "scale", Vector2(1.0, 1.0), 0.1, Tween.TRANS_EXPO)
		add_tween(key_label, "rotation", 0.0, 0.1, Tween.TRANS_EXPO)

func add_tween(object, property: String, value, seconds: float, transition_type) -> void:
	curr_tween = get_tree().create_tween()
	curr_tween.tween_property(object, property, value, seconds).set_trans(transition_type)
