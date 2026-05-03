class_name DamageEvent

var amount: int
var type: String
var source: Node
var knockback: Vector2

func _init(_amount: int, _type: String = "default", _source: Node = null, _knockback: Vector2 = Vector2.ZERO):
	amount = _amount
	type = _type
	source = _source
	knockback = _knockback
