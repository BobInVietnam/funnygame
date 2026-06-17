extends PanelContainer

@onready var _label: Label = $MarginContainer/Label
@export var title_text: String:
	set(value):
		title_text = value
		if is_node_ready():
			_label.text = value
	get:
		return title_text

func _ready() -> void:
	_label.text = title_text
