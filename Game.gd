class_name Game extends Node;

@export var start_level: PackedScene;
@export var start_ui: PackedScene;

@onready var world = $"World";
@onready var ui_slot = $"UI";
@onready var music = $"Music";

var game_started = false;

func _ready() -> void:
	load_level(start_level);
	load_ui(start_ui);
	
func play_music(audio: AudioStream, loop = true):
	music.stream = audio;
	music.play();
	
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
