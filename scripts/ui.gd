extends CanvasLayer

@onready var princess_healthbar: ProgressBar = $VBoxContainer/ProgressBar
@onready var princess_title: Label = $VBoxContainer/Princess
@onready var boss_vbox: VBoxContainer = $VBoxContainer2
@onready var boss_healthbar: ProgressBar = $VBoxContainer2/ProgressBar
@onready var ammo_indicator: TextureRect = $AmmoType
@onready var wintext = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_vbox.visible = false
	pass # Replace with function body.

func _on_princess_princess_down(current_retry: int) -> void:
	princess_title.text = "Công Túa\nMạng: " + str(current_retry)


func _on_princess_princess_hurt(current_health: int) -> void:
	princess_healthbar.value = current_health


func _on_boss_enter_combat() -> void:
	boss_vbox.visible = true

func _on_boss_hurt(current_health: int) -> void:
	boss_healthbar.value = current_health


func _on_boss_down() -> void:
	wintext.visible = true
