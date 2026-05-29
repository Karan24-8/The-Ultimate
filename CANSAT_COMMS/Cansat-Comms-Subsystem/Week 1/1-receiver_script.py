#Receiver script

import serial

#Use another end of the virtual COM pair.
ser = serial.Serial('COM10', 9600)

try:
  print("Listening for data on COM10...")
  while True:
    if ser.in_waiting > 0:  #This line checks if there is any data currently waiting in the serial input buffer to be read?
      line = ser.readline().decode('utf-8').strip()
      print(f"Received: {line}")
except KeyboardInterrupt:
  ser.close()
  print("Receiver stopped.")



#This script will receive, "Hello, Cansat!" every second.