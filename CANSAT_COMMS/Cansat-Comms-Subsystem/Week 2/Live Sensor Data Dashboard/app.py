from flask import Flask, jsonify, render_template_string
import serial
import threading
import time

app = Flask(__name__)

# Global variable to store latest temperature value
latest_temperature = "No data yet"

# Configure serial port
ser = serial.Serial('COM11', 9600, timeout=1)

def read_serial():
    global latest_temperature
    while True:
        try:
            if ser.in_waiting:
                line = ser.readline().decode('utf-8').strip()
                latest_temperature = line
                print(f"Received: {line}")
            time.sleep(0.1)
        except Exception as e:
            print(f"Serial read error: {e}")
            time.sleep(1)

# Start serial reading thread
threading.Thread(target=read_serial, daemon=True).start()

@app.route('/')
def index():
    # Simple HTML with JavaScript to auto-update
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Live Temperature</title>
        <script>
            function fetchData() {
                fetch('/get_data').then(response => response.json()).then(data => {
                    document.getElementById('temp').innerText = data.temperature;
                });
            }
            setInterval(fetchData, 2000); // Refresh every 2 sec
            window.onload = fetchData;
        </script>
    </head>
    <body>
        <h1>Live Temperature Reading</h1>
        <h2 id="temp">Loading...</h2>
    </body>
    </html>
    """
    return render_template_string(html)

@app.route('/get_data')
def get_data():
    return jsonify({'temperature': latest_temperature})

if __name__ == '__main__':
    app.run(debug=True, use_reloader=False)
