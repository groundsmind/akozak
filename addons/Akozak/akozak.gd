@tool
extends EditorPlugin

const AUTOLOAD_NAME = "GlobalInteractData"
const SCRIPT_PATH = "res://addons/Akozak/Scripts/GlobalInteractData.gd"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, SCRIPT_PATH)

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
