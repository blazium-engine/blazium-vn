extends Node
class_name Game

@onready var pause_menu = %PauseMenu
@onready var end_menu = %EndMenu

@onready var pause_checker_sprite = $PauseChecker

func _ready() -> void:
	
	#Imported from .rk example	
	Rakugo.sg_say.connect(_on_say)
	Rakugo.sg_step.connect(_on_step)
	Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
  
	Rakugo.parse_and_execute_script(file_path)
	
	#Items left over from the template (may or may not need to be removed)
	if SaveHelper.save_file_name_to_load.is_empty():
		return
	
	if not SaveHelper.load_saved_file_name() == OK:
		return
	
	pause_checker_sprite.rotation = \
		SaveHelper.last_loaded_data.get("pause_checker_sprite_rot", 0)


func _process(_delta):
	if pause_menu.visible == false and Input.is_action_just_pressed("ui_cancel"):
		pause_menu.show()
		pause_menu.set_process(true)
		get_tree().paused = true
		
	if Rakugo.is_waiting_step() and Input.is_action_just_pressed("ui_accept"):
		Rakugo.do_step()

func _on_win():
	end_menu.set_win()
	end_menu.show()
	get_tree().paused = true
	
func _on_gameover():
	end_menu.set_gameover()
	end_menu.show()
	get_tree().paused = true

func _on_pause_menu_ask_to_save() -> void:
	pause_menu.save_this_please({
		"pause_checker_sprite_rot":pause_checker_sprite.rotation
	})

func _on_blazia_who_pressed():
	SceneLoader.change_scene("res://scenes/BlaziaIntro/BlaziaIntro.tscn")

func _on_mainMenu():
	SceneLoader.change_scene("res://scenes/Game/game.tscn")

func _on_faq_pressed():
	SceneLoader.change_scene("res://scenes/BlaziaFAQ/BlaziaFAQ.tscn")

func _on_history_pressed():
	SceneLoader.change_scene("res://scenes/Game/game.tscn")

func _on_blazia_dynamic_pressed():
	SceneLoader.change_scene("res://scenes/BlaziaDynamic/BlaziaDynamic.tscn")

#Imported from the .rk example
const file_path = "res://Timeline.rk"

func _on_say(character:Dictionary, text:String):
	prints("Say", character.get("name", ""), text)
  
func _on_step():
	prints("Press \"Enter\" to continue...")
	
func _on_execute_script_finished(file_name:String, error_str:String):
	prints("End of script")
  
