@tool
class_name UiIcon extends HBoxContainer

@export var icon: Texture;
@export var text: String;

@onready var icon_sprite = $Icon;
@onready var label_text = $Label;

func _ready() -> void:
	icon_sprite.texture = icon;
	label_text.text = text;

func _process(delta: float) -> void:
	if icon_sprite.texture != icon:
		icon_sprite.texture = icon;
	if label_text.text != text:
		label_text.text = text;
		
