extends Node3D

@onready var skele = $Hand/RootNode/Armature/Skeleton3D
const hand = "left"
const idmap = {1: "thumb", 4: "index", 8: "middle", 12: "ring", 16: "pinky"}
const pinch_threshold = 0.8

func to_quat(array: Array) -> Quaternion:
	return Quaternion(array[0], array[1], array[2], array[3])

func quat_flip(quat: Quaternion, x: bool, y: bool, z: bool, w: bool) -> Quaternion:
	if x: quat.x *= -1
	if y: quat.y *= -1
	if z: quat.z *= -1
	if w: quat.w *= -1
	return quat

func to_vec3(array: Array) -> Vector3:
	return Vector3(array[0], array[1], array[2])

func _ready() -> void:
	var bones = []
	for i in range(skele.get_bone_count()):
		bones.append(skele.get_bone_name(i))
	print(bones)
	LeapMotionClient.open("127.0.0.1", 42069)

func _process(_delta: float) -> void:
	var new_data = LeapMotionClient.poll()
	if new_data:
		var pinch_strength = LeapMotionClient.hand_data[hand]["pinch_strength"]
		
		var event = InputEventAction.new()
		event.action = "interact"
		event.pressed = (pinch_strength > pinch_threshold)
		Input.parse_input_event(event)
		
		var palm_ori = LeapMotionClient.hand_data[hand]["palm"]["orientation"]
		var palm_quat = to_quat(palm_ori)
		#skele.set_bone_pose_rotation(0, palm_quat)
		var acc_quat = palm_quat
		for finger_id in [1, 4, 8, 12, 16]:
			var i = 0
			for bone in ["metacarpal", "proximal", "intermediate", "distal"]:
				if bone == "metacarpal" and finger_id == 1:
					continue
				var bon = LeapMotionClient.hand_data[hand][idmap[finger_id]][bone]
				var rot = bon["rotation"]
				var quat = to_quat(rot)
				skele.set_bone_pose_rotation(finger_id+i, quat+acc_quat)
				acc_quat += quat
				i += 1
		pass
