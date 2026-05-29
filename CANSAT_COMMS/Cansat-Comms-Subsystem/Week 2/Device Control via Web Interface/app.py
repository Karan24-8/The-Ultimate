from flask import Flask, render_template_string, request
import serial
import time

app = Flask(__name__)

# Connect to COM11 (Flask side)
ser = serial.Serial('COM11', 9600, timeout=1)

HTML_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>ESP32 LED Control</title>
</head>
<body>
    <h1>ESP32 LED Control (Simulator)</h1>
    <form method="post">
        <button name="action" value="ON">Turn ON</button>
        <button name="action" value="OFF">Turn OFF</button>
    </form>
    <h2>Status: {{ status }}</h2>
</body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def control():
    status = "Unknown"
    if request.method == 'POST':
        action = request.form['action']
        ser.reset_input_buffer()  # Clear any old data
        ser.write(f"{action}\n".encode())

        # Wait for reply
        time.sleep(0.5)

        if ser.in_waiting:
            response = ser.readline().decode().strip()
            if response:
                status = response
            else:
                status = "No response"
        else:
            status = "No response from simulator"

        return render_template_string(HTML_PAGE, status=status)

if __name__ == '__main__':
    app.run(debug=True, use_reloader = False)
