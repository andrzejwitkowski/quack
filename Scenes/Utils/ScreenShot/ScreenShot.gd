extends Node3D


@onready var stats_label: Label = $CanvasLayer/StatsLabel
@onready var timer: Timer = $Timer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		var dt = Time.get_datetime_dict_from_system()
		var suffix = "%02d_%02d_%02d_%02d_%02d" % [dt.month, dt.day, dt.hour, dt.minute, dt.second]
		var image = get_viewport().get_texture().get_image()
		image.save_png("user://screenshot_%s.png" % suffix)
	if event.is_action_pressed("stats"):
		stats_label.visible = !stats_label.visible


func update_stats() -> void:
	var fps = Engine.get_frames_per_second()
	var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var primitives = Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)
	var obj_count = Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	var vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / (1024 * 1024)
	var ds: String = "FPS: %d\nDraw Calls: %d\nPrimitives: %d\nObjects: %d\nVRAM: %.1f MB" % [
		fps, draw_calls, primitives, obj_count, vram
	]
	stats_label.text = ds


func _on_timer_timeout() -> void:
	update_stats()
