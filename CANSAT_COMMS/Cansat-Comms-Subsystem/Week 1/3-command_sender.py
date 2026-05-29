import serial

#Connecting Python script to port COM12
ser = serial.Serial('COM12', 9600, timeout=1)

print("Command sender connected to COM12")

while True:
  user_input = input("Enter command (ON/OFF): ").strip().upper()

  if user_input in ["ON", "OFF"]:
    ser.write((user_input + "\n").encode())
    print(f"Sent: {user_input}")

    #Waiting for reply
    reply = ser.readline().decode().strip()
    if reply:
      print(f"ESP32 replied: {reply}")
    else:
      print("No reply received.")
  else:
    print("Invalid Command. Enter ON or OFF.")