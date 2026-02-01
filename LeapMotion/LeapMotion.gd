class_name LeapMotion
extends Node

var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()

var hand_data = null
var hand_position = null

func open(host: String, port: int) -> bool:
	print("LeapMotion: Connecting to %s:%d" % [host, port])
	_status = _stream.STATUS_NONE
	if _stream.connect_to_host(host, port) != OK:
		print("LeapMotion: Error connecting to the LeapProvider!")
		return false
	_stream.poll()
	_status = _stream.get_status()
	if _status == _stream.STATUS_CONNECTED:
		print("LeapMotion: Connected to LeapProvider!")
		return true
	else:
		print("LeapMotion: Error connecting to the LeapProvider!")
		return false
	
func poll() -> bool:
	_stream.poll()
	_status = _stream.get_status()
	if _status == _stream.STATUS_CONNECTED:
		_stream.put_data(PackedByteArray([0]))
		var available_bytes = _stream.get_available_bytes()
		if available_bytes > 0:
			var data = _stream.get_utf8_string(available_bytes)
			var json = JSON.new()
			var error = json.parse(data)
			
			if error == OK:
				hand_data = json.data
				
				var pos = hand_data["left"]["palm"]["position"]
				hand_position = Vector2(clamp((pos[0]+120)/240, 0, 1), clamp((pos[2]+67.5)/135, 0, 1))
				
				return true
	return false
