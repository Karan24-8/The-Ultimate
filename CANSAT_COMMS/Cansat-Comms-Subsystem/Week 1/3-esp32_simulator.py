import serial

#Connecting ESP32 simulator to port COM11
ser = serial.Serial('COM11', 9600, timeout=1)

print("ESP32 simulator listening on COM11...")

while True:
  if ser.in_waiting > 0:
    command = ser.readline().decode().strip().upper()
    print(f"Received command: {command}")

    if command == 'ON':
      ser.write(b"LED ON\n")
    elif command == 'OFF':
      ser.write(b"LED OFF\n")
    else:
      ser.write(b"Unknown command.\n")