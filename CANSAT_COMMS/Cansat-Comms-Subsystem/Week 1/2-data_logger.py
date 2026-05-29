import serial
import csv
from datetime import datetime

#Connecting to the receiving COM port
ser = serial.Serial('COM10', 9600, timeout=1)

#Creating the csv file.
csv_filename = "cansatdata.csv"

#Setting up the csv file.
try:
  with open(csv_filename, 'x', newline='') as f:       #Creating the file
    writer = csv.writer(f)
    writer.writerow(['Timestamp', ' SensorValue'])   #Writes the header row.
except FileExistsError:
  pass             #Skip if file already exists.     

print("Started logging data to cansatdata.csv...")


#Loop to append the logger data in csv file.
while True:
  if ser.in_waiting > 0:
    line = ser.readline().decode().strip()
    if line.isdigit():           #Ensuring the data is numeric.
      timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')         #Formatting the timestamp.
      print(f"[{timestamp}] Received: {line}")           #Console's output.

      with open(csv_filename, 'a', newline='') as f:       #Opening the file in append mode.
        writer = csv.writer(f)
        writer.writerow([timestamp, line])         #Writes the timestamp along with the data.