class_name InteractHintComponent
extends SubViewport

const PROMPT = preload("res://addons/Akozak/Nodes/ActionPrompt.tscn")
@onready var control_root: Control = $Control
@onready var prompt_container: VBoxContainer = $Control/CenterContainer/PromptContainer

@export var pixels_per_world_unit: float = 400.0
@export var content_padding: Vector2 = Vector2(16, 16)
@export var progress_bg_color: Color = Color("#FFF")
@export var progress_line_color: Color = Color("#00FF00AA")

var sprite
var prompts_by_action: Dictionary = {}

var eo_tween

func _ready() -> void:
	sprite = get_parent()
	sprite.centered = true
	if sprite is Sprite3D:
		sprite.pixel_size = 1.0 / pixels_per_world_unit
	GlobalInteractData.interaction_available.connect(_on_interaction_available)
	GlobalInteractData.interaction_unavailable.connect(_on_interaction_unavailable)
	GlobalInteractData.action_state_changed.connect(_on_action_state_changed)

func _on_interaction_available(interacts: Array[InteractAction], interact_area: InteractArea) -> void:
	for child in prompt_container.get_children():
		child.queue_free()
	prompts_by_action.clear()

	for action in interacts:
		var new_prompt = PROMPT.instantiate()
		prompt_container.add_child(new_prompt)
		
		new_prompt.set_bound_action(action)
		new_prompt.set_progbar_color(progress_bg_color, progress_line_color)
		new_prompt.set_text_color(action.text_color)
		prompts_by_action[action] = new_prompt
		if not action.visible:
			new_prompt.hide()

	await _fit_viewport_to_content()
	
	if GlobalInteractData.current_area != interact_area:
		return

	if is_instance_valid(interact_area.hint_marker):
		if sprite is Sprite3D:
			sprite.global_transform.origin = interact_area.hint_marker.global_transform.origin
		else:
			sprite.global_transform.origin = interact_area.hint_marker.global_transform.origin - Vector2(0,sprite.texture.get_size().y/8)
	else:
		if interact_area.hint_marker:
			push_warning("InteractArea '%s' has a hint_marker set but it's not a valid instance; falling back to default offset." % interact_area.name)
		sprite.global_transform.origin = interact_area.parent_area.global_transform.origin + (Vector3(0.0, 0.5, 0.0) if sprite is Sprite3D else Vector2(0.0, -10.0))
	sprite.show()
	
	var stagger_delay: float = 0.1
	var index: int = 0
	for child in prompt_container.get_children():
		if child.visible:
			child._fade_slide_in(stagger_delay * index)
			index+=1

func _fit_viewport_to_content() -> void:
	await get_tree().process_frame
	var content_size: Vector2 = (prompt_container.get_combined_minimum_size() + content_padding).ceil()
	var slide_buffer: float = 40.0
	content_size.x += slide_buffer*2
	size = content_size
	control_root.size = content_size
	sprite.offset = Vector2((-content_size.x / 2.0) + (slide_buffer / 2.0), content_size.y / 2.0)

func _on_interaction_unavailable() -> void:
	var stagger_delay: float = 0.08
	var valid_index: int = 0
	var exit_tweens: Array[Tween] = []
	for child in prompt_container.get_children():
		if child.visible and child.has_method("_fade_slide_out"):
			var tween = child._fade_slide_out(valid_index * stagger_delay)
			if tween:
				exit_tweens.append(tween)
				valid_index += 1
	
	while not exit_tweens.is_empty():
		var last_tween = exit_tweens.pop_back()
		if is_instance_valid(last_tween) and last_tween.is_valid():
			await last_tween.finished
			break
	for prompt in prompt_container.get_children():
		prompt.queue_free()
	prompts_by_action.clear()
	sprite.hide()

func _on_action_state_changed(action: InteractAction) -> void:
	if prompts_by_action.has(action):
		prompts_by_action[action].refresh_enabled_state()
	await _fit_viewport_to_content()
