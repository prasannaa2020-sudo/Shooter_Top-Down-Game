class_name MainMenu
extends Control

## Title screen: pick a fighter, an enemy type and a level, then start playing.

const LEVEL_SCENE := "res://game/level.tscn"

@onready var fighter_row: HBoxContainer = $Center/Panel/FighterRow
@onready var fighter_desc: Label = $Center/Panel/FighterDesc
@onready var enemy_row: HBoxContainer = $Center/Panel/EnemyRow
@onready var enemy_desc: Label = $Center/Panel/EnemyDesc
@onready var level_grid: GridContainer = $Center/Panel/LevelGrid
@onready var level_desc: Label = $Center/Panel/LevelDesc
@onready var quit_button: Button = $Center/Panel/QuitButton

func _ready() -> void:
	_build_fighters()
	_build_enemy_types()
	_build_levels()
	quit_button.pressed.connect(func() -> void: get_tree().quit())

func _build_fighters() -> void:
	var group: ButtonGroup = ButtonGroup.new()
	for entry in Roster.CHARACTERS:
		var button: Button = _make_button(entry["name"], Vector2(150, 46))
		button.toggle_mode = true
		button.button_group = group
		button.button_pressed = entry["id"] == GameState.character_id
		button.pressed.connect(_select_fighter.bind(entry))
		button.mouse_entered.connect(func() -> void: fighter_desc.text = entry["desc"])
		fighter_row.add_child(button)
	fighter_desc.text = Roster.character(GameState.character_id)["desc"]

func _select_fighter(entry: Dictionary) -> void:
	GameState.character_id = entry["id"]
	fighter_desc.text = entry["desc"]

func _build_enemy_types() -> void:
	var group: ButtonGroup = ButtonGroup.new()
	var options: Array[Dictionary] = [{"id": "mixed", "name": "MIXED", "desc": "Each level keeps its own alien line-up."}]
	for entry in Roster.ENEMIES:
		options.append(entry)
	for entry in options:
		var button: Button = _make_button(entry["name"], Vector2(130, 44))
		button.toggle_mode = true
		button.button_group = group
		button.button_pressed = entry["id"] == GameState.enemy_id
		button.pressed.connect(_select_enemy.bind(entry))
		button.mouse_entered.connect(func() -> void: enemy_desc.text = entry["desc"])
		enemy_row.add_child(button)
	enemy_desc.text = _enemy_description(GameState.enemy_id)

func _select_enemy(entry: Dictionary) -> void:
	GameState.enemy_id = entry["id"]
	enemy_desc.text = _enemy_description(entry["id"])

func _enemy_description(id: String) -> String:
	if id == "mixed":
		return "Each level keeps its own alien line-up."
	return Roster.enemy(id)["desc"]

func _build_levels() -> void:
	for i in LevelData.LEVELS.size():
		var data: Dictionary = LevelData.LEVELS[i]
		var button: Button = _make_button(str(i + 1), Vector2(150, 44))
		var info: String = "%s  -  %s" % [data["name"], data["desc"]]
		button.pressed.connect(_start_level.bind(i))
		button.mouse_entered.connect(func() -> void: level_desc.text = info)
		button.focus_entered.connect(func() -> void: level_desc.text = info)
		level_grid.add_child(button)
	level_desc.text = "Click a level number to play it."

func _start_level(index: int) -> void:
	GameState.level_index = index
	get_tree().change_scene_to_file(LEVEL_SCENE)

func _make_button(label: String, size: Vector2) -> Button:
	var button: Button = Button.new()
	button.text = label
	button.custom_minimum_size = size
	button.add_theme_font_size_override("font_size", 18)
	return button
