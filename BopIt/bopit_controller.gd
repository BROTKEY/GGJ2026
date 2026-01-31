extends Node


@export
var bopit_device_name = "BopIt-ESP32" # Name of the BLE device

@export
var scan_duration = 10.0 # Scan duration in Seconds

@export
var autoconnect = false # Automatically start scan when initialized


var ble: BluetoothManager = null
var bopit_device: BleDevice = null

const BLE_SERVICE = "12345678-1234-1234-1234-1234567890ab"

const CHARA_PLAY_BOP 	= "12345678-1234-1234-1234-1234567890d1"
const CHARA_PLAY_TWIST 	= "12345678-1234-1234-1234-1234567890d2"
const CHARA_PLAY_PULL 	= "12345678-1234-1234-1234-1234567890d3"

const CHARA_GET_BOP 	= "12345678-1234-1234-1234-1234567890c1"
const CHARA_GET_TWIST	= "12345678-1234-1234-1234-1234567890c2"
const CHARA_GET_PULL 	= "12345678-1234-1234-1234-1234567890c3"

const CHARA_SETTING_TIMEOUT = "12345678-1234-1234-1234-1234567890e1" # 4-Byte Little Endian (ms)
const CHARA_SETTING_LANG 	= "12345678-1234-1234-1234-1234567890e2" # String (en,de,fr)
const CHARA_SETTING_VOLUME 	= "12345678-1234-1234-1234-1234567890e3" # 1-Byte (0-21)


enum BopItAction
{
	BOP,
	TWIST,
	PULL
}

# Which properties should be polled on every frame?
var polling_states = {
	BopItAction.BOP: false,
	BopItAction.TWIST: false,
	BopItAction.PULL: false,
}

# Flags for the last received states
var action_flags = {
	BopItAction.BOP: false,
	BopItAction.TWIST: false,
	BopItAction.PULL: false,
}

const action_to_chara = {
	BopItAction.BOP: CHARA_GET_BOP,
	BopItAction.TWIST: CHARA_GET_TWIST,
	BopItAction.PULL: CHARA_GET_PULL,
}

const chara_to_action = {
	CHARA_GET_BOP: BopItAction.BOP,
	CHARA_GET_TWIST: BopItAction.TWIST,
	CHARA_GET_PULL: BopItAction.PULL,
}


func start_scan() -> void:
	ble.start_scan(scan_duration)


func enable_polling(action: BopItAction) -> void:
	action_flags[action] = false
	polling_states[action] = true


func disable_polling(action: BopItAction) -> void:
	polling_states[action] = false
	action_flags[action] = false


func _ready() -> void:
	disconnect_all()
	
	ble = BluetoothManager.new()
	add_child(ble)
	
	ble.adapter_initialized.connect(_on_adapter_initialized)
	ble.device_discovered.connect(_on_device_found)
	ble.scan_stopped.connect(_on_scan_stopped)
	
	ble.initialize()


func _process(_delta: float) -> void:
	if bopit_device != null and bopit_device.is_connected():
		if polling_states[BopItAction.BOP]:
			bopit_device.read_characteristic(BLE_SERVICE, CHARA_GET_BOP)
		if polling_states[BopItAction.TWIST]:
			bopit_device.read_characteristic(BLE_SERVICE, CHARA_GET_TWIST)
		if polling_states[BopItAction.PULL]:
			bopit_device.read_characteristic(BLE_SERVICE, CHARA_GET_PULL)


func _on_adapter_initialized(success: bool, error: String):
	if success:
		print("Bluetooth initialized successfully")
		if autoconnect:
			start_scan()
	else:
		print("Bluetooth initialization failed: ", error)


func _on_device_found(device_info):
	var device_name = device_info.get("name", "")
	if device_name == "BopIt-ESP32":
		ble.stop_scan()
		
		var address = device_info.get("address")
		print("Device found: ", device_name)
		print("  Address: ", address)
		print("  Signal strength: ", device_info.get("rssi"), " dBm")
		
		connect_to_device(address)


func _on_scan_stopped():
	print("Scan complete")


func connect_to_device(address: String):
	print("Connecting to: ", address)
	# Connect to device
	bopit_device = ble.connect_device(address)
	if bopit_device:
		# Connect device signals
		bopit_device.connected.connect(_on_device_connected)
		bopit_device.disconnected.connect(_on_device_disconnected)
		bopit_device.services_discovered.connect(_on_services_discovered)
		bopit_device.characteristic_written.connect(_on_characteristic_written)
		bopit_device.characteristic_read.connect(_on_characteristic_read)
		
		# Start connection
		bopit_device.connect_async()


func _on_device_connected():
	print("Device connected")
	# Discover services
	bopit_device.discover_services()


func _on_services_discovered(services: Array):
	print("Discovered ", services.size(), " services")
	
	# Iterate through services and characteristics
	for service in services:
		var CHARA_uuid = service.get("uuid")
		print("[SERVICE] ", CHARA_uuid)
		var characteristics = service.get("characteristics", [])
		
		for characteristic in characteristics:
			var char_uuid = characteristic.get("uuid")
			print("[CHAR] ", char_uuid)


func _on_characteristic_written(char_uuid: String):
	print("Data written successfully: ", char_uuid)


func _on_characteristic_read(char_uuid: String, data: PackedByteArray) -> void:
	print("[RECV] ", char_uuid, " -> ", data)
	if char_uuid in chara_to_action:
		assert(data.size() > 0)
		var action: BopItAction = chara_to_action[char_uuid]
		action_flags[action] = polling_states[action] and (data[0] != 0)


func disconnect_all() -> void:
	if ble != null:
		for dev in ble.get_connected_devices():
			dev.disconnect()


func _on_device_disconnected():
	print("disconnected")


func _exit_tree() -> void:
	disconnect_all()


func _on_button_pressed() -> void:
	disconnect_all()
