class_name Game extends Node;

@export var start_level: PackedScene;
@export var start_ui: PackedScene;
@export var extents = Vector2(1500, 1500);
@export var max_entity_sounds = 4;

@export var ingredient_types: Array[IngredientType];

@onready var world = $"World";
@onready var ui_slot = $"UI";
@onready var music = $"Music";

signal cooking_started;
signal cooking_ended;
signal game_over;

var _music_queue: Array[AudioStream];

var game_started = false;
var sounds_playing = 0;

var pack = {};

var cooking = false;
var cooking_timer = 0.0;

var quota = 1000;
var current_points = 0;

var time_left = 0;

func _ready() -> void:
	load_level(start_level);
	load_ui(start_ui);
	
	
func _process(delta: float) -> void:
	if !game_started:
		return;
		
	time_left -= delta;
	
	if time_left <= 0:
		time_left = 0
		
		if cooking:
			cooking = false;
			cooking_ended.emit();
			
		if current_points < quota:
			game_over.emit();
	
	if cooking:
		cooking_timer -= delta;
		if cooking_timer <= 0:
			cooking = false;
			cooking_ended.emit();
			print("Cooking done!");


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
	time_left = 100; # Make this configurable
	quota = 1000;
	current_points = 0;
	
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


func stock_pot():
	if cooking:
		pass
	elif !pack.is_empty():
		var multiplier = pack.size();
		var points = 0;
		
		for key in pack:
			points += pack[key];
		
		pack.clear(); # TODO: check recipe if ready
		
		current_points += points * multiplier;
		
		cooking = true;
		cooking_timer = 10; # This should be based on recipe
		cooking_started.emit();


func _on_music_finished() -> void:
	music.stream = _music_queue.pop_front();
	if music.stream:
		music.play();
