extends Control

@export var types: Array[IngredientType];
@export var icon_scene: PackedScene;

@onready var pack = $Pack;
@onready var soup = $Pack/Soup;
@onready var timer_lable = $Timer;
@onready var game_over_ui = $GameOver;

var _icons = {};

func _ready() -> void:
	Global.game.cooking_started.connect(func ():
		for key in _icons:
			_icons[key].queue_free();
		_icons.clear();
	);
	
	Global.game.game_over.connect(func ():
		game_over_ui.visible = true;
		)

func _process(delta: float) -> void:
	soup.text = "%d / %d" % [Global.game.current_points, Global.game.quota];
	timer_lable.text = "%d" % Global.game.time_left;
	
	for key in Global.game.pack:
		var text = "%d" % Global.game.pack[key];
		if _icons.has(key):
			_icons[key].text = text;
		else:
			var icon = icon_scene.instantiate();
			icon.text = text;
			icon.icon = Global.game.ingredient_types[key].sprite;
			pack.add_child(icon);
			_icons[key] = icon;

