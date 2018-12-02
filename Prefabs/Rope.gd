extends Line2D

export (NodePath) var surchage_hand
var hand

func _process(delta):
	rotation = -$"..".rotation
	if hand or surchage_hand:
		if not hand:
			hand = get_node(surchage_hand)
		var pos_point = hand.get_global_position() - get_global_position()
		if get_point_count() < 2:
			add_point(pos_point)
		else:
			set_point_position(1, pos_point)
	elif get_point_count() >= 2:
		remove_point(1)
