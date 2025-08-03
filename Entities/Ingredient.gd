extends CharacterBody2D

@export var speed = 400;
@export var flee_cooldown = 0.5;
@export var surprise_cooldown = 0.2;
@export var rotation_speed = 2.0;
@export var random_pitch_diff = 0.2;

@export var sound_pack: SoundPack;

@onready var sprite = $"Sprite2D";
@onready var audio_player = $"AudioStreamPlayer2D";

var _players: Array[Node2D];

enum State {
    Spawned,
    Idle,
    Wandering,
    Suprised,
    Fleeing,
}

var _state = State.Spawned;
var _dir = Vector2.ZERO;
var _flee_timer = 0.0;
var _surprise_timer = 0.0;
var _rotation_timer = 0.0;

@onready var _target = self.position;
@export var wander_range = 400;
@export var wander_cooldown_min = 1.0;
@export var wander_cooldown_max = 2.0;
var _wander_timer = randf_range(wander_cooldown_min, wander_cooldown_max);

func _process(delta: float) -> void:
    _rotation_timer += rotation_speed * delta;
    sprite.rotation = sin(_rotation_timer) * 0.25 * _dir.length_squared();
    
    match _state:
        State.Spawned:
            _state = State.Idle;
            
        State.Idle:
            if not _players.is_empty():
                _surprise();
                return;
            
            _wander_timer -= delta;
            
            if _wander_timer <= 0:
                _wander();
            
            _dir = Vector2.ZERO;
            
        State.Wandering:
            if (_target - self.position).length_squared() < 100:
                _state = State.Idle;
                return;
            _dir = (_target - self.position).normalized();
            
        State.Suprised:
            _surprise_timer -= delta;
            if _surprise_timer <= 0.0:
                _flee();
        State.Fleeing:
            if _players.is_empty() && _flee_timer <= 0 && not audio_player.playing:
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
    
func _exit_tree() -> void:
    if audio_player.playing:
        audio_player.stop();
        Global.game.sounds_playing -= 1;
    
func _surprise():
    _state = State.Suprised;
    _surprise_timer = surprise_cooldown;
    _play_sound(sound_pack.random_surprise_sound());

func _flee():
    _state = State.Fleeing;
    _flee_timer = flee_cooldown;
    _play_sound(sound_pack.random_flee_sound());
    
func _play_sound(stream: AudioStream):
    if Global.game.can_play_more_sounds():
        audio_player.stream = stream;
        audio_player.pitch_scale = 1.0 + randf_range(-random_pitch_diff, random_pitch_diff);
        audio_player.play();
        Global.game.sounds_playing += 1;
   
func _wander():
    _state = State.Wandering;
    var angle = randf() * TAU;
    _target = position + Vector2(cos(angle), sin(angle)) * randf() * wander_range;
    _wander_timer = randf_range(wander_cooldown_min, wander_cooldown_max);


func _on_detector_body_entered(body: Node2D) -> void:
    _players.push_back(body);


func _on_detector_body_exited(body: Node2D) -> void:
    var i = _players.find(body);
    if i != -1:
        _players.remove_at(i);


func _on_audio_stream_player_2d_finished() -> void:
    Global.game.sounds_playing -= 1;
