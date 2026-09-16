class_name InteractArea3D
extends Area3D

@onready var timer: Timer
signal action_start(action: InteractSource)
signal action_cancel(action: InteractSource)
signal action_finish(action: InteractSource)
signal interaction_available
signal interaction_unavailable
var action_timer: SceneTreeTimer
var action_over: bool = false

@export var interactions: Array[InteractSource] = []

func _ready() -> void:
	set_process_unhandled_input(false)

func _process(_delta: float) -> void:
	if action_over:
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo():
		var key = event.keycode
		for action in interactions:
			if key == action.key:
				if event.is_pressed():
					action_start.emit(action)
					GlobalInteractData.is_interacting(action)
					action_timer = get_tree().create_timer(action.duration)
					action_timer.timeout.connect(_on_interaction_finish.bind(action))
					action_timer.timeout.connect(GlobalInteractData.finished_interaction.bind(action))
				if event.is_released():
					action_cancel.emit(action)
					action_timer = null
					GlobalInteractData.finished_interaction(action)

func _on_area_entered(_area: Area3D) -> void:
	set_process_unhandled_input(true)
	GlobalInteractData.set_interactor(interactions, self)
	interaction_available.emit()

func _on_area_exited(_area: Area3D) -> void:
	set_process_unhandled_input(false)
	GlobalInteractData.clear_interactor()
	interaction_unavailable.emit()

func _on_interaction_finish(action):
	action_finish.emit(action)
