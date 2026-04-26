extends Interactable

@export var password = "1234"

@onready var safe_ui: CanvasLayer = %SafeUI
@onready var password_label: RichTextLabel = %RichTextLabel

var _password: String = "0000"
var is_unlocked = false

func interact():
	if not is_unlocked:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		password_label.text = _password
		safe_ui.show()

func button_pressed(input: String):
	match input:
		"CLEAR":
			%ButtonClickSFX.play()
			print("clear")
			_password = "0000"
			password_label.text = _password
		"OK":
			print("ok")
			if _password == password:
				print("Password Correct")
				%CorrectSFX.play()
				is_unlocked = true
				close()
				%AnimationPlayer.play("open")
				set_script(null)
			else:
				print("Password Wrong")
				%ErrorSFX.play()

		_:
			%ButtonClickSFX.play()
			print(input)
			_password = _password.erase(0, 1)
			_password = _password.insert(3, input)
			password_label.text = _password

func close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	safe_ui.hide()