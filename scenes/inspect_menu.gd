extends Control

@onready var item_holder = $Background/SubViewport/ItemHolder

@export var zoom_speed: float = 0.05
@export var min_zoom: float = -0.5
@export var max_zoom: float = -2.0

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open_inspect(item_path: String):
	for child in item_holder.get_children():
		child.queue_free()
	
	var scene = load(item_path)
	if scene:
		var item = scene.instantiate()

		item.top_level = false
		
		item_holder.add_child(item) 
		
		item.position = Vector3.ZERO
		item.rotation = Vector3.ZERO

		show()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close_menu():
	#ลบไอเทมที่ดึงมาแสดงเมื่อปิดหน้าจอ
	for child in item_holder.get_children():
		child.queue_free()

	hide()
	get_tree().paused = false

	item_holder.position.z = (min_zoom + max_zoom) / 2

func _input(event):
	if not visible: 
		return
	
	# ใช้ Input (ตัวใหญ่) สำหรับเช็คการกดปุ่ม Action
	if Input.is_action_just_pressed("ui_cancel"):
		close_menu()
	
	# ส่วนการหมุน (ใช้ event เพราะต้องเอาค่า relative ของเมาส์)
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		item_holder.rotate_y(event.relative.x * 0.01)
		item_holder.rotate_x(event.relative.y * 0.01)
	
	# ส่วนการซูม (ใช้ event เพราะต้องเช็คว่าเป็นลูกกลิ้งเมาส์หรือไม่)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			item_holder.position.z = clamp(item_holder.position.z + zoom_speed, max_zoom, min_zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			item_holder.position.z = clamp(item_holder.position.z - zoom_speed, max_zoom, min_zoom)
