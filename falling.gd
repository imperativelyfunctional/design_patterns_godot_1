extends Area2D

func _on_body_entered(_body):
	EventBus.emit_signal("falling")
