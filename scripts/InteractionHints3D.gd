extends Sprite3D

const PROMPT = preload("uid://cq1enxi7px6dw")
@onready var sub_viewport: SubViewport = $SubViewport
@onready var control_root: Control = $SubViewport/Control
@onready var prompt_container: VBoxContainer = $SubViewport/Control/CenterContainer/PromptContainer

@export var pixels_per_world_unit: float = 400.0
@export var content_padding: Vector2 = Vector2(16, 16)

var prompts_by_action: Dictionary = {}

func _ready() -> void:
	centered = true
	pixel_size = 1.0 / pixels_per_world_unit
	GlobalInteractData.interaction_available.connect(_on_interaction_available)
	GlobalInteractData.interaction_unavailable.connect(_on_interaction_unavailable)
	GlobalInteractData.action_enabled_changed.connect(_on_action_enabled_changed)

func _on_interaction_available(interacts: Array[InteractAction], interact_area: InteractArea3D) -> void:
	for child in prompt_container.get_children():
		child.queue_free()
	prompts_by_action.clear()

	for action in interacts:
		var new_prompt = PROMPT.instantiate()
		prompt_container.add_child(new_prompt)
		new_prompt.set_bound_action(action)
		prompts_by_action[action] = new_prompt

	await _fit_viewport_to_content()

	if is_instance_valid(interact_area.hint_marker):
		global_transform.origin = interact_area.hint_marker.global_transform.origin
	else:
		if interact_area.hint_marker:
			push_warning("InteractArea3D '%s' has a hint_marker set but it's not a valid instance; falling back to default offset." % interact_area.name)
		global_transform.origin = interact_area.global_transform.origin + Vector3(0.0, 0.5, 0.0)
	show()

func _fit_viewport_to_content() -> void:
	await get_tree().process_frame
	var content_size: Vector2 = (prompt_container.get_combined_minimum_size() + content_padding).ceil()
	sub_viewport.size = content_size
	control_root.size = content_size
	offset = Vector2(-content_size.x / 2.0, content_size.y / 2.0)

func _on_interaction_unavailable() -> void:
	for prompt in prompt_container.get_children():
		prompt.queue_free()
	prompts_by_action.clear()
	hide()

func _on_action_enabled_changed(action: InteractAction) -> void:
	if prompts_by_action.has(action):
		prompts_by_action[action].refresh_enabled_state()
