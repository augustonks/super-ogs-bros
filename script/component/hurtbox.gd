class_name Hurtbox
extends Area3D

signal hitbox_entered

func _on_area_entered(area: Area3D) -> void:
	print("oi")
	if area is Hitbox:
		emit_signal("hitbox_entered", area)
