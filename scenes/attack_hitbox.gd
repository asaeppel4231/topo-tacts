extends Area2D

@export var damage_amount: int = 10
@export var knockback: Vector2 = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("apply_damage"):
		var dmg = DamageEvent.new(damage_amount, "enemy", self, knockback)
		body.apply_damage(dmg)
