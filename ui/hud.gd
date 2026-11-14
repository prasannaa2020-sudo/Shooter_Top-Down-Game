class_name Hud
extends CanvasLayer

## In-level interface: health / enemies left on top, plus the win-lose panel.
## Runs with PROCESS_MODE_ALWAYS so its buttons still work while the tree is paused.

signal next_pressed
signal retry_pressed
signal menu_pressed

@onready var health_label: Label = $TopBar/HealthLabel
@onready var level_label: Label = $TopBar/LevelLabel
@onready var enemies_label: Label = $TopBar/EnemiesLabel
@onready var overlay: Control = $Overlay
@onready var title_label: Label = $Overlay/Center/Panel/TitleLabel
@onready var sub_label: Label = $Overlay/Center/Panel/SubLabel
@onready var next_button: Button = $Overlay/Center/Panel/Buttons/NextButton
@onready var retry_button: Button = $Overlay/Center/Panel/Buttons/RetryButton
@onready var menu_button: Button = $Overlay/Center/Panel/Buttons/MenuButton

func _ready() -> void:
	overlay.visible = false
	next_button.pressed.connect(func() -> void: next_pressed.emit())
	retry_button.pressed.connect(func() -> void: retry_pressed.emit())
	menu_button.pressed.connect(func() -> void: menu_pressed.emit())

func set_health(health: int, max_health: int) -> void:
	health_label.text = "HEALTH %d / %d" % [health, max_health]

func set_enemies(count: int) -> void:
	enemies_label.text = "ALIENS LEFT %d" % count

func set_level_name(level_name: String) -> void:
	level_label.text = level_name

func show_result(title: String, subtitle: String, show_next: bool, show_retry: bool) -> void:
	title_label.text = title
	sub_label.text = subtitle
	next_button.visible = show_next
	retry_button.visible = show_retry
	overlay.visible = true
	if show_next:
		next_button.grab_focus()
	elif show_retry:
		retry_button.grab_focus()
	else:
		menu_button.grab_focus()
