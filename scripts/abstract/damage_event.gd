class_name DamageEvent

var amount: float
var type: String
var source: Node
var knockback: Vector2
var direct_die: bool

func _init(_amount: float, _type: String = "default", _source: Node = null, 
_knockback: Vector2 = Vector2.ZERO, _direct_die: bool = false) -> void:
	amount = _amount
	type = _type
	source = _source
	knockback = _knockback
	direct_die = _direct_die
