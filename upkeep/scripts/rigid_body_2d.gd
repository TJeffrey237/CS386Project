extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.freeze = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var W_carry = "WASD_carry"
	var A_carry = "Arrow_carry"
	var WASD_adj = is_player_adjacent(get_node("../WASD"))
	#var Arrow_adj = is_player_adjacent(get_node("../Arrows"))
	if WASD_adj and Input.is_action_just_pressed(W_carry, true):
		pick_up(get_node("../WASD"), W_carry)
		#self.MODE_RIGID
	#if Arrow_adj:
	#	pick_up("Arrows")

func pick_up(player, carryer):
	var playerPosition = player.position
	var boxPosition = self.position
	var positionDiff = playerPosition - boxPosition
	while(playerPosition != player.position && carryer == true ):
		var NewBoxPos = player.position - boxPosition
		self.position = NewBoxPos
	
func is_player_adjacent(player):
	var distanceX = abs(player.global_position.x - global_position.x)
	var distanceY = abs(player.global_position.y - global_position.y)
	#print(distanceX, ",", distanceY)
	if (distanceX > 49 and distanceX < 51) or (distanceY > 74 and distanceY < 76):
		return true
	return false
	
func _input(event: InputEvent) -> void:
	pass
