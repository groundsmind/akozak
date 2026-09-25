class_name BaseArea
extends Node

var _area
var is_3d: bool = false

func _init(target_area: Node) -> void:
	_area = target_area
	is_3d = target_area is Area3D

func get_overlapping_areas() -> Array:
	return _area.get_overlapping_areas()

func get_overlapping_bodies() -> Array:
	return _area.get_overlapping_bodies()

func has_overlapping_areas() -> bool:
	return _area.has_overlapping_areas()

func has_overlapping_bodies() -> bool:
	return _area.has_overlapping_bodies()

func overlaps_area(area: Node) -> bool:
	return _area.overlaps_area(area)

func overlaps_body(body: Node) -> bool:
	return _area.overlaps_body(body)

func connect_body_entered(callable: Callable, flags: int = 0) -> int:
	return _area.body_entered.connect(callable, flags)

func connect_body_exited(callable: Callable, flags: int = 0) -> int:
	return _area.body_exited.connect(callable, flags)

func connect_area_entered(callable: Callable, flags: int = 0) -> int:
	return _area.area_entered.connect(callable, flags)

func connect_area_exited(callable: Callable, flags: int = 0) -> int:
	return _area.area_exited.connect(callable, flags)
