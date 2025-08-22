class_name Pot extends StaticBody2D

@onready var sprite = $Sprite2D;
@onready var boiling_sound = $BoilingWaterSound;

var cooking = false;
var cooking_time = 0.0;

func _ready() -> void:
	Global.game.cooking_started.connect(func ():
		cooking = true
		boiling_sound.play();
		);
	Global.game.cooking_ended.connect(func ():
		cooking = false;
		cooking_time = 0.0;
		boiling_sound.stop();
		)

func _process(delta: float) -> void:
	if cooking:
		cooking_time += delta;
		
	sprite.rotation = sin(cooking_time) * 0.25;
