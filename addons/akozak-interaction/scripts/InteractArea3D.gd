class_name InteractArea3D
extends Area3D

signal action_start(action: InteractAction)
signal action_cancel(action: InteractAction)
signal action_finish(action: InteractAction)
signal interaction_available
signal interaction_unavailable
var action_over: bool = false
var active_action: InteractAction = null

@export var interactions: Array[InteractAction] = []
@export var hint_marker: Marker3D

func _ready() -> void:
	set_process_unhandled_input(false)
	GlobalInteractData.interaction_finish.connect(_on_global_interaction_finish)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo():
		var key = event.keycode
		for action in interactions:
			if key == action.key and action.enabled:
				if event.is_pressed():
					active_action = action
					send_start(action)
					if not action.hold:
						send_finish(action)
				elif event.is_released() and active_action == action:
					if action.hold and not action_over:
						send_cancel(action)
					active_action = null
				break

func disable_action(action_hint: String) -> void:
	set_action_enabled_state(action_hint, false)

func enable_action(action_hint: String) -> void:
	set_action_enabled_state(action_hint, true)

func hide_action(action_hint: String) -> void:
	set_action_visible_state(action_hint, false)

func show_action(action_hint: String) -> void:
	set_action_visible_state(action_hint, true)


func set_action_enabled_state(action_hint: String, is_enabled: bool) -> void:
	for action in interactions:
		if action.hint == action_hint:
			action.enabled = is_enabled
			if GlobalInteractData.current_area == self:
				GlobalInteractData.action_state_changed.emit(action)
			break

func set_action_visible_state(action_hint: String, is_shown: bool) -> void:
	for action in interactions:
		if action.hint == action_hint:
			set_action_enabled_state(action_hint, is_shown)
			action.visible = is_shown
			if GlobalInteractData.current_area == self:
				GlobalInteractData.action_state_changed.emit(action)
			break

func send_start(action) -> void:
	action_over = false
	action_start.emit(action)
	GlobalInteractData.current_action = action 
	GlobalInteractData.interaction_start.emit(action)
	if action.hold:
		GlobalInteractData.start_hold_timer(action.duration, action) 

func send_cancel(action) -> void:
	action_cancel.emit(action)
	GlobalInteractData.interaction_cancel.emit(action)

func send_finish(action) -> void:
	GlobalInteractData.interaction_finish.emit(action)

func _on_global_interaction_finish(action: InteractAction) -> void:
	if action == active_action:
		action_over = true
		action_finish.emit(action)
		active_action = null

func _on_area_entered(_area: Area3D) -> void:
	set_process_unhandled_input(true)
	GlobalInteractData.set_interactor(interactions, self)
	interaction_available.emit()

func _on_area_exited(_area: Area3D) -> void:
	set_process_unhandled_input(false)
	GlobalInteractData.clear_interactor()
	interaction_unavailable.emit()
