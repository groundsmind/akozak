extends HBoxContainer

@onready var key_label: Label = $CenterContainer/KeyLabel
@onready var hint_label: Label = $HintLabel
@onready var progress_bar: TextureProgressBar = $CenterContainer/ProgressBar

var bound_action: InteractAction
var curr_action: InteractAction
var is_animating_bar_reset: bool = false
var target_modulate: Color = Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	await get_tree().process_frame
	key_label.pivot_offset = key_label.size / 2
	progress_bar.value = 0.0
	GlobalInteractData.interaction_start.connect(_bump)
	GlobalInteractData.interaction_start.connect(set_current_action)
	GlobalInteractData.interaction_cancel.connect(_on_interaction_end)
	GlobalInteractData.interaction_finish.connect(_on_interaction_end)

func _process(delta: float) -> void:
	if curr_action == bound_action and is_instance_valid(GlobalInteractData.action_timer):
		progress_bar.value = progress_bar.max_value - GlobalInteractData.time_left
	elif is_animating_bar_reset:
		progress_bar.value = move_toward(progress_bar.value, 0.0, delta * 400.0)
		if progress_bar.value == 0.0:
			is_animating_bar_reset = false
	key_label.scale = lerp(key_label.scale, Vector2(1.0, 1.0), delta * 5.0)
	key_label.rotation = lerp(key_label.rotation, 0.0, delta * 5.0)
	
	modulate = lerp(modulate, target_modulate, delta * 6.0)

func _on_interaction_end(action: InteractAction) -> void:
	if action == bound_action:
		is_animating_bar_reset = true

func set_current_action(action: InteractAction) -> void:
	curr_action = action

func refresh_enabled_state() -> void:
	if bound_action.enabled:
		target_modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		target_modulate = Color(0.5, 0.5, 0.5, 0.5)
	
	if bound_action.visible:
		show()
	else:
		hide()

func set_bound_action(gid_action: InteractAction) -> void:
	bound_action = gid_action
	key_label.text = OS.get_keycode_string(bound_action.key)
	hint_label.text = bound_action.hint
	progress_bar.max_value = bound_action.duration
	
	if bound_action.enabled:
		target_modulate = Color(1.0, 1.0, 1.0, 1.0)
		if modulate == Color(1.0, 1.0, 1.0, 1.0): 
			modulate = Color(0.5, 0.5, 0.5, 0.5)
	else:
		target_modulate = Color(0.5, 0.5, 0.5, 0.5)
		modulate = Color(0.5, 0.5, 0.5, 0.5)

func _bump(action) -> void:
	set_current_action(action)
	if bound_action.enabled and action == bound_action:
		is_animating_bar_reset = false 
		key_label.scale = Vector2(2.0, 0.5)
		key_label.rotation += randf_range(deg_to_rad(-45), deg_to_rad(45))
