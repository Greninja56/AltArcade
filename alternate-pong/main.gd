extends Node2D

@export var win_score := 7

@onready var ball = $Ball
@onready var player_label = $PlayerScore
@onready var comp_label = $ComputerScore
@onready var win_label = $WinLabel

var player_score := 0
var comp_score := 0
var game_over := false

func _on_left_goal_body_entered(body):  
	if body != ball or game_over:
		return
	comp_score += 1
	comp_label.text = str(comp_score)
	if comp_score >= win_score:
		end_game("Computer wins!")
	else:
		ball.reset(-1)

func _on_right_goal_body_entered(body): 
	if body != ball or game_over:
		return
	player_score += 1
	player_label.text = str(player_score)
	if player_score >= win_score:
		end_game("You win!")
	else:
		ball.reset(1)

func end_game(message):
	game_over = true
	ball.set_physics_process(false)  
	ball.visible = false
	win_label.text = message + "\nPress Enter to play again"
	win_label.visible = true

func _unhandled_input(event):
	if game_over and event.is_action_pressed("ui_accept"):
		restart()

func restart():
	player_score = 0
	comp_score = 0
	player_label.text = "0"
	comp_label.text = "0"
	win_label.visible = false
	game_over = false
	ball.visible = true
	ball.set_physics_process(true)
	ball.reset()
