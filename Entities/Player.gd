extends CharacterBody2D

@export var speed = 400;
@export var range = 400;
@export var throw_speed = 800;
@export var rotation_speed = 8.0;

@onready var lasso_target = $"LassoTarget";
@onready var lasso_visual = $"LassoVisual";
@onready var sprite = $"PlayerSprite";

var _using_joystick = false;
var _dir = Vector2.ZERO;
var _state = State.Moving;
var _rotation_timer = 0.0;

var _entities_in_lasso: Array[Node2D] = [];
var _lasso_throw_distance = 0;

enum State {
	Moving = 0,
	LassoCharge,
	LassoThrow,
	LassoRecall,
}


func _input(event: InputEvent) -> void:
	match _state:
		State.Moving:
			if event.is_action_pressed("Lasso Start"):
				_state = State.LassoCharge;
		State.LassoCharge:
			if event.is_action_released("Lasso Start"):
				_state = State.LassoThrow;
		State.LassoThrow:
			pass
		State.LassoRecall:
			pass


func _process(delta: float) -> void:
	if not Global.game.game_started:
		lasso_target.visible = false;
		lasso_visual.visible = false;
		return;
		
	_rotation_timer += rotation_speed * delta;
	sprite.rotation = sin(_rotation_timer) * 0.25 * _dir.length_squared();
	
	if _dir.x < 0:
		sprite.flip_h = false;
	elif _dir.x > 0:
		sprite.flip_h = true;
	
	match _state:
		State.Moving:
			lasso_target.visible = true;
			lasso_visual.visible = false;
			
			_dir.x = Input.get_axis("Move Left", "Move Right");
			_dir.y = Input.get_axis("Move Up", "Move Down");
			
			if not _using_joystick:
				lasso_target.position = get_local_mouse_position().limit_length(range);
		
		_:
			_dir = Vector2.ZERO;


func _physics_process(delta: float) -> void:
	match _state:
		State.LassoThrow:
			_lasso_throw_distance += throw_speed * delta;
			
			lasso_target.visible = false;
			lasso_visual.visible = true;
			lasso_visual.position = lasso_target.position.limit_length(_lasso_throw_distance);
			
			if _lasso_throw_distance >= _lasso_target_distance():
				_state = State.LassoRecall;

				for entity in _entities_in_lasso:
					if entity is Ingredient:
						Global.game.collect(entity.type);
						entity.queue_free();
					elif entity is Pot:
						Global.game.stock_pot();
					
					
		State.LassoRecall:
			_lasso_throw_distance -= throw_speed * delta;
			
			lasso_target.visible = false;
			lasso_visual.visible = true;
			lasso_visual.position = lasso_target.position.limit_length(_lasso_throw_distance);
			
			if _lasso_throw_distance <= 0:
				_state = State.Moving;
	
	self.velocity = _dir * speed;
	self.move_and_slide();


func _on_lasso_body_entered(body: Node2D) -> void:
	print(body);
	_entities_in_lasso.push_back(body);


func _on_lasso_body_exited(body: Node2D) -> void:
	var i = _entities_in_lasso.find(body);
	if i >= 0:
		_entities_in_lasso.remove_at(i);

func _lasso_target_distance() -> float:
	return lasso_target.position.length();
