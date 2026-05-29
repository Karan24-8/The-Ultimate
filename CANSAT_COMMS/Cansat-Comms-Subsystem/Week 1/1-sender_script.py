#Sender script

import serial
import time

ser = serial.Serial('COM9', 9600)

try:
  while True:
    message = "Hello, Cansat!\n"
    ser.write(message.encode('utf-8'))
    print(f"Sent: {message.strip()}")
    time.sleep(1)
except KeyboardInterrupt:
  ser.close()
  print("Sender stopped.")


#This script will send, "Hello, Cansat!" every second to COM10 (simulating ESP32)