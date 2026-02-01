import leap
import socket
import threading

from leap.events import TrackingEvent
from leap.datatypes import Vector, Quaternion

import json


class LeapProvider:
    running = False


    def __init__(self, leaplistener: "LeapListener", addr="127.0.0.1", port=42069):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((addr, port))
        self.sock.listen(4)
        self.connection_handler = threading.Thread(target=self.connection_handler)
        self.leap = leaplistener

        print("Opened Socket on: {}:{}".format(addr, port))

    def connection_handler(self):
        while self.running:
            client, addr = self.sock.accept()

            print("Client {} connected!".format(addr))
            client_thread = threading.Thread(target=self.client_handler, args=(client, addr))
            client_thread.run()

    def client_handler(self, client, addr):
        while True:
            data = json.dumps(self.leap.hand_data)

            try:
                client.send(bytes(data, 'utf-8'))
                data = client.recv(1024)
            except ConnectionResetError:
                break

            if not data:
                break

        print("Client {} disconnected!".format(addr))
        client.close()

    def start(self):
        self.running = True
        self.connection_handler.start()

    def stop(self):
        self.running = False
        self.sock.close()

    def __del__(self):
        self.stop()


class LeapListener(leap.Listener):

    hand_data = {
        "left": {
            "pinch_distance": 0,
            "pinch_strength": 0,
            "palm": {
                "position": (0, 0, 0),
                "stabilized_position": (0, 0, 0),
                "normal": (0, 0, 0),
                "direction": (0, 0, 0),
                "orientation": (0, 0, 0, 0)
            },
            "thumb": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "index": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "middle": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "ring": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "pinky": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
        },
        "right": {
            "pinch_distance": 0,
            "pinch_strength": 0,
            "palm": {
                "position": (0, 0, 0),
                "stabilized_position": (0, 0, 0),
                "normal": (0, 0, 0),
                "direction": (0, 0, 0),
                "orientation": (0, 0, 0, 0)
            },
            "thumb": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "index": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "middle": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "ring": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
            "pinky": {
                "metacarpal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "proximal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "intermediate": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                },
                "distal": {
                    "prev_joint": (0, 0, 0),
                    "next_joint": (0, 0, 0),
                    "rotation": (0, 0, 0, 0)
                }
            },
        },
    }

    def on_connection_event(self, event):
        print("Connected")

    def on_device_event(self, event):
        try:
            with event.device.open():
                info = event.device.get_info()
        except leap.LeapCannotOpenDeviceError:
            info = event.devide.get_info()

        print("Found device {}".format(info))

    def on_tracking_event(self, event: TrackingEvent):
        for hand in event.hands:
            handt = "left" if str(hand.type) == "HandType.Left" else "left" # TODO: VERY IMPORTANT THAT THIS HAS TO BE CHANGED IF USED OUTSIDE GGJ2026 DON'T BLAME ME, I WARNED YOU

            for prop in ["pinch_distance", "pinch_strength"]:
                self.hand_data[handt][prop] = getattr(hand, prop)

            for prop in self.hand_data[handt]["palm"].keys():
                vec = getattr(hand.palm, prop)
                if prop == "orientation":
                    self.hand_data[handt]["palm"][prop] = (vec.x, vec.y, vec.z, vec.w)
                else:
                    self.hand_data[handt]["palm"][prop] = (vec.x, vec.y, vec.z)
            
            for finger in ["thumb", "index", "middle", "ring", "pinky"]:
                for bone in self.hand_data[handt][finger].keys():
                    for prop in self.hand_data[handt][finger][bone]:
                        data = None
                        raw_data = getattr(getattr(getattr(hand, finger), bone), prop)
                        if type(raw_data) == Vector:
                            data = (raw_data.x, raw_data.y, raw_data.z)
                        elif type(raw_data) == Quaternion:
                            data =  (raw_data.x, raw_data.y, raw_data.z, raw_data.w)
                        self.hand_data[handt][finger][bone][prop] = data
            

def main():
    listener = LeapListener()

    connection = leap.Connection()
    connection.add_listener(listener)

    with connection.open():
        connection.set_tracking_mode(leap.TrackingMode.Desktop)
        provider = LeapProvider(listener)
        provider.start()

        input("Press Enter to Exit")

        provider.stop()
        exit(0)


if __name__ == "__main__":
    main()
