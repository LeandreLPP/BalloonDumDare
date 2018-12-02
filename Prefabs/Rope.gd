extends Line2D

var hand

func _process(delta):
	rotation = -$"..".rotation
	if hand:
		var pos_point = hand.get_global_position() - get_global_position()
		if get_point_count() < 2:
			add_point(pos_point)
		else:
			set_point_position(1, pos_point)
	else:
		remove_point(1)
