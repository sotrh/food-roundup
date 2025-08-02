extends CharacterBody2D

@export var speed = 400;
@export var flee_cooldown = 0.5;
@export var surprise_cooldown = 0.2;

var _players: Array[Node2D];

enum State {
	Idle,
	Suprised,
	Fleeing,
}

var _state = State.Idle;
var _dir = Vector2.ZERO;
var _flee_timer = 0.0;
var _surprise_timer = 0.0;

func _process(delta: float) -> void:
	match _state:
		State.Idle:
			if not _players.is_empty():
				_state = State.Suprised;
				_surprise_timer = surprise_cooldown;
				return;
			
			_dir = Vector2.ZERO;
		State.Suprised:
			_surprise_timer -= delta;
			if _surprise_timer <= 0.0:
				_state = State.Fleeing;
		State.Fleeing:
			if _players.is_empty() && _flee_timer <= 0:
				_state = State.Idle;
				return;
				
			_flee_timer -= delta;
				
			if not _players.is_empty():
				_flee_timer = flee_cooldown;
				var pos = Vector2.ZERO;
				for p in _players:
					pos += p.global_position;
				_dir = (global_position - pos / _players.size()).normalized();
			
func _physics_process(delta: float) -> void:
	velocity = _dir * speed;
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	_players.push_back(body);


func _on_detector_body_exited(body: Node2D) -> void:
	var i = _players.find(body);
	if i != -1:
		_players.remove_at(i);
