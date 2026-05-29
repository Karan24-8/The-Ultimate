import serial
import time
import random

ser = serial.Serial('COM12', 9600)

while True:
    temp = round(random.uniform(20.0, 35.0), 2)
    ser.write(f"{temp}\n".encode())
    print(f"Sent: {temp}")
    time.sleep(2)
