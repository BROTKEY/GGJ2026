extends Node

var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()

var hand_data = null

func open(host: String, port: int) -> bool:
	print("LeapMotion: Connecting to %s:%d" % [host, port])
	_status = _stream.STATUS_NONE
	if _stream.connect_to_host(host, port) != OK:
		print("LeapMotion: Error connecting to the LeapProvider!")
		return false
	return true
	
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
				return true
	return false
