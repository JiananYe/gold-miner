extends Node2D

const WIDTH_MIN = 120
const WIDTH_MAX = 1800
const HEIGHT_MIN = 560
const HEIGHT_MAX = 900
const GOLD_MIN = 2
const GOLD_MAX = 4
const GEM_MIN = 0
const GEM_MAX = 2
const BOMB_MIN = 3
const BOMB_MAX = 4
const STONE_MIN = 3
const STONE_MAX = 4
const SIZE_MIN = 1
const SIZE_MAX = 2

onready var pts_label = $HUD/Points_Label
onready var life_container = $HUD/VBoxContainer/Life_Container
onready var time_left = $HUD/VBoxContainer/Time_Left
onready var gold = load("res://Objects/Gold.tscn")
onready var gem = load("res://Objects/Diamond.tscn")
onready var bomb = load("res://Objects/Bomb.tscn")
onready var stone = load("res://Objects/Stone.tscn")
onready var life_scene = load("res://HUD/Life.tscn")
onready var points = 0
onready var life = 3

func _ready():
	pts_label.text = "points: " + str(points)
	update_life()
	generate_level()
	$Timer.start(60)

func _process(delta):
	time_left.text = str(round($Timer.get_time_left()))
	if (get_tree().get_nodes_in_group("Valueables").size() <= 0):
		get_tree().change_scene("res://HUD/Win.tscn")
		
func _on_Player_area_entered(area):
	if (area.is_in_group("Gold")):
		points += area.scale.x * 100
		pts_label.text = "points: " + str(points)
		area.queue_free()
	if (area.is_in_group("Diamond")):
		points += area.scale.x * 500
		pts_label.text = "points: " + str(points)
		area.queue_free()
	if (area.is_in_group("Stone")):
		points += area.scale.x * 10
		pts_label.text = "points: " + str(points)
		area.queue_free()
	if (area.is_in_group("Bomb")):
		life -= 1
		lose_life()
		area.queue_free()
		if (life <= 0):
			get_tree().change_scene("res://HUD/GameOver.tscn")


func update_life():
	for n in life:
		life_container.add_child(life_scene.instance())

func lose_life():
	life_container.get_child(life_container.get_child_count()-1).queue_free()

func generate_level():
	var random = RandomNumberGenerator.new()
	random.randomize()

	
	var gold_count = random.randi_range(GOLD_MIN, GOLD_MAX)
	var gem_count = random.randi_range(GEM_MIN, GEM_MAX)
	var bomb_count = random.randi_range(BOMB_MIN, BOMB_MAX)
	var stone_count = random.randi_range(STONE_MIN, STONE_MAX)
	
	for n in gold_count:
		var instance = gold.instance()
		var size = random.randi_range(SIZE_MIN, SIZE_MAX)
		instance.scale = Vector2(size, size)
		instance.position = Vector2(random.randi_range(WIDTH_MIN, WIDTH_MAX), random.randi_range(HEIGHT_MIN, HEIGHT_MAX))
		add_child(instance)
	
	for n in stone_count:
		var instance = stone.instance()
		var size = random.randi_range(SIZE_MIN, SIZE_MAX)
		instance.scale = Vector2(size, size)
		instance.position = Vector2(random.randi_range(WIDTH_MIN, WIDTH_MAX), random.randi_range(HEIGHT_MIN, HEIGHT_MAX))
		add_child(instance)

	for n in bomb_count:
		var instance = bomb.instance()
		instance.position = Vector2(random.randi_range(WIDTH_MIN, WIDTH_MAX), random.randi_range(HEIGHT_MIN, HEIGHT_MAX))
		add_child(instance)

	for n in gem_count:
		var instance = gem.instance()
		instance.position = Vector2(random.randi_range(WIDTH_MIN, WIDTH_MAX), random.randi_range(HEIGHT_MIN, HEIGHT_MAX))
		add_child(instance)

func _on_Timer_timeout():
	get_tree().change_scene("res://HUD/GameOver.tscn")
