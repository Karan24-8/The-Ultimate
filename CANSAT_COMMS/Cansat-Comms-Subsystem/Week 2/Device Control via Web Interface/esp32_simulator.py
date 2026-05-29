import serial

ser = serial.Serial('COM12', 9600)  # Use COM12 for simulator

print("ESP32 Simulator is running...")

while True:
    if ser.in_waiting:
        command = ser.readline().decode().strip()
        print(f"Received: {command}")

        if command == "ON":
            response = "LED ON\n"
        elif command == "OFF":
            response = "LED OFF\n"
        else:
            response = "Unknown Command\n"

        ser.write(response.encode())
        print(f"Sent: {response.strip()}")
