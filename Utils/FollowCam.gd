extends Camera2D

@export_node_path("CharacterBody2D") var player_path;
@onready var player: CharacterBody2D = get_node(player_path);

func _process(delta: float) -> void:
	global_position = clamp_pos_to_viewport(player.global_position);

func clamp_pos_to_viewport(pos: Vector2) -> Vector2:
	var view_port_extents = get_viewport_rect().size * 0.5;
	var max_pos = Global.game.extents - view_port_extents;
	var min_pos = -max_pos;
	
	return Vector2(
		max(min_pos.x, min(max_pos.x, pos.x)),
		max(min_pos.y, min(max_pos.y, pos.y)),
	)
