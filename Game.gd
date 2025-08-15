class_name Game extends Node;

@export var start_level: PackedScene;
@export var start_ui: PackedScene;
@export var extents = Vector2(1500, 1500);
@export var max_entity_sounds = 4;

@onready var world = $"World";
@onready var ui_slot = $"UI";
@onready var music = $"Music";

var _music_queue: Array[AudioStream];

var game_started = false;
var sounds_playing = 0;

var pack = {};
var carrots = 0;


func _ready() -> void:
	load_level(start_level);
	load_ui(start_ui);
	
	
func _process(delta: float) -> void:
	pass


func play_music(audio: AudioStream):
	_music_queue.push_back(audio);
	if not music.playing:
		music.stream = _music_queue.pop_front();
		music.play();
	

func can_play_more_sounds() -> bool:
	return sounds_playing < max_entity_sounds;
	

func start_game() -> void:
	game_started = true;


func load_level(level: PackedScene):
	if level == null:
		return;
		
	for child in world.get_children():
		child.queue_free();
	
	world.add_child(level.instantiate());


func load_ui(ui: PackedScene):
	if ui == null:
		return;
	
	for child in ui_slot.get_children():
		child.queue_free();
		
	ui_slot.add_child(ui.instantiate());


func collect(item: IngredientType):
	if pack.has(item.id):
		pack[item.id] += item.value;
	else:
		pack[item.id] = item.value;


func _on_music_finished() -> void:
	music.stream = _music_queue.pop_front();
	if music.stream:
		music.play();
