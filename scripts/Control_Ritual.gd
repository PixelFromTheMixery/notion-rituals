extends Control

@onready var label_step: Label = $Label_Step
@onready var label_timer: Label = $Label_Timer
@onready var one_sec_timer: Timer = $Timer_OneSec
@onready var step_timer: Timer = $Timer_Step
@onready var write: TextEdit = $Tedit_Entry
@onready var pause: Button = $Button_Pause
@onready var back: Button = $HBox_Controls/Button_Back
@onready var notify: AudioStreamPlayer = $Audio_TimedOut

var step_count: int
var journal: bool
var result: Array

func _on_button_start_pressed():
	step_count = 0
	result = []
	ritual_step()
	
func ritual_step():
	step_timer.stop()
	write.text = ""
	if step_count == 0:
		back.disabled = true
	else:
		back.disabled = false
	if step_count+1 > global.ritual.size():
		signals.submit_result.emit(result)
	else:	
		if global.ritual[step_count][1].contains("?"):
			journal = true
			write.show()
		else:
			journal = false
			write.hide()

		step_timer.wait_time = global.ritual[step_count][2] * 60
		step_timer.start()
		one_sec_timer.start()

		label_step.text = global.ritual[step_count][1]
		label_timer.text = translate_time(int(step_timer.time_left))

func _on_timer_one_sec_timeout():
	label_timer.text = translate_time(int(step_timer.time_left))

func translate_time(time_left: int):
	var minutes = time_left / 60
	var seconds = time_left % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_timer_step_timeout():
	notify.play()
	step_timer.stop()
	one_sec_timer.stop()

func _on_button_back_pressed():
	step_count -= 1
	ritual_step()	

func _on_button_skip_pressed():
	result.append(
			[
				global.ritual[step_count][0] + ' - ' + 
				str(global.ritual[step_count][2]) + " - " + 
				global.ritual[step_count][1],
				"Skipped"
			]
		)
	step_count += 1
	ritual_step()

func _on_button_done_pressed():
	if journal:
		result.append(
			[
				global.ritual[step_count][0] + ' - ' + 
				str(global.ritual[step_count][2]) + " - " + 
				global.ritual[step_count][1],
				write.text
			]
		)
	else:
		var time_left = translate_time(
			global.ritual[step_count][2] * 60 - 
			int(step_timer.time_left)
		)
		result.append(
			[
				global.ritual[step_count][0] + ' - ' + 
				str(global.ritual[step_count][2]) + " - " + 
				global.ritual[step_count][1],
				time_left
			]
		)
	step_count += 1
	ritual_step()

func _on_button_pause_toggled(toggled_on:bool):
	one_sec_timer.paused = toggled_on
	step_timer.paused = toggled_on

	if toggled_on:
		pause.text = "Play"
	else:
		pause.text = "Pause"
