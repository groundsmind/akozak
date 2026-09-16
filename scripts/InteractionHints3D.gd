extends Sprite3D

const PROMPT = preload("uid://cq1enxi7px6dw")
@onready var prompt_container: VBoxContainer = $SubViewport/Control/CenterContainer/PromptContainer

func _ready() -> void:
	GlobalInteractData.interaction_available.connect(_on_interaction_available)
	GlobalInteractData.interaction_unavailable.connect(_on_interaction_unavailable)

func _process(_delta: float) -> void:
	pass

func _on_interaction_available(interacts: Array[InteractSource], interact_area: InteractArea3D) -> void:
	for action in interacts:
		var new_prompt = PROMPT.instantiate()
		prompt_to_action(new_prompt, action)
		prompt_container.add_child(new_prompt)
		
	global_transform.origin = interact_area.global_transform.origin + Vector3(0.0, 0.5, 0.0)
	show()

func _on_interaction_unavailable() -> void:
	for prompt in prompt_container.get_children():
		prompt.queue_free()
	hide()

func prompt_to_action(prompt: Control, action: InteractSource) -> void:
	prompt.connect_action(action)
