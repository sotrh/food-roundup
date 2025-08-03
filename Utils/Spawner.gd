class_name Spawner extends Node2D

@export var entity_scene: PackedScene;
@export var spawn_cooldown = 1.0;
@export var spawn_radius = 400;

var _spawn_timer = 0;

func _process(delta: float) -> void:
	if _spawn_timer <= 0:
		var entity: Node2D = entity_scene.instantiate();
		var offset = Vector2(cos(randf() * TAU), sin(randf() * TAU)) * spawn_radius * randf();
		entity.global_position = self.global_position + offset;
		get_parent().add_child(entity);
		_spawn_timer = spawn_cooldown;
	
	_spawn_timer -= delta;
