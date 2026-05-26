extends Area2D

@export var damage_amount: float = 10.0
@export var knockback: Vector2 = Vector2.ZERO
@export var direct_die: bool

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("apply_damage"):
		var dmg = DamageEvent.new(damage_amount, "enemy", self, knockback, direct_die)
		body.apply_damage(dmg)
