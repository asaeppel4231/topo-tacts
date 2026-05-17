extends HasAnimationsHelper
class_name HasMovementHelper

func exit():
	base.idle_timer.stop()
	super.exit()
