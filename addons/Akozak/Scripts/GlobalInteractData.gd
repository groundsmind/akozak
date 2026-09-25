extends Node

var available_actions: Array[InteractAction]
var current_area: InteractArea

var current_key: Key
var current_action: InteractAction
var action_timer: SceneTreeTimer
var time_left: float = 0.0

@warning_ignore("unused_signal") signal interaction_start(interaction: InteractAction)
@warning_ignore("unused_signal") signal interaction_cancel(interaction: InteractAction)
signal interaction_finish(interaction: InteractAction)
signal interaction_available(interacts: Array[InteractAction], interact_area: InteractArea)
signal interaction_unavailable()
@warning_ignore("unused_signal") signal action_state_changed(action: InteractAction)

func _ready() -> void:
	interaction_cancel.connect(_on_interaction_cancel)
	interaction_finish.connect(_on_interaction_finish)

func _process(_delta: float) -> void:
	if action_timer:
		time_left = action_timer.time_left

func set_interactor(action: Array[InteractAction], interact_area: InteractArea) -> void:
	available_actions = action
	current_area = interact_area
	interaction_available.emit(action, interact_area)

func clear_interactor() -> void:
	available_actions = []
	current_area = null
	interaction_unavailable.emit()

func start_hold_timer(wait_time: float, action: InteractAction) -> void:
	current_action = action
	var timer := get_tree().create_timer(wait_time)
	action_timer = timer
	timer.timeout.connect(func():
		if action_timer == timer:
			interaction_finish.emit(action)
	)

func _on_interaction_cancel(_action) -> void:
	_cleanup_timer()
	 
func _on_interaction_finish(_action) -> void:
	_cleanup_timer()

func _cleanup_timer() -> void:
	action_timer = null
	time_left = 0.0
