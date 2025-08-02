extends Camera2D

@export_node_path("CharacterBody2D") var player_path;
@onready var player: CharacterBody2D = get_node(player_path);

func _process(delta: float) -> void:
	global_position = player.global_position;
