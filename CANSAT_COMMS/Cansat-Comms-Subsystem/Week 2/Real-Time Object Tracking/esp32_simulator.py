import serial
import time

ser = serial.Serial('COM12', 9600)
print("ESP32 GPS simulator running...")

coords = [
    (19.0760, 72.8777),  # Mumbai
    (28.7041, 77.1025),  # Delhi
    (12.9716, 77.5946),  # Bangalore
    (13.0827, 80.2707),  # Chennai
]

while True:
    for lat, lon in coords:
        message = f"{lat},{lon}\n"
        ser.write(message.encode())
        print(f"Sent: {message.strip()}")
        time.sleep(5)  # send every 5 seconds
