#I tried getting the apikey for this project, but i have run out of Projects limit on Google Cloud.

from flask import Flask, render_template_string, jsonify
import serial
import threading

app = Flask(__name__)

ser = serial.Serial('COM11', 9600, timeout=1)

latest_coords = {"lat": 0, "lon": 0}

def read_serial():
    global latest_coords
    while True:
        if ser.in_waiting:
            line = ser.readline().decode().strip()
            if "," in line:
                try:
                    lat_str, lon_str = line.split(",")
                    latest_coords["lat"] = float(lat_str) #Parsing
                    latest_coords["lon"] = float(lon_str) #Parsing
                    print(f"Updated coords: {latest_coords}")
                except ValueError:
                    print(f"Invalid line: {line}")

# Start serial reader in background
thread = threading.Thread(target=read_serial, daemon=True)
thread.start()

HTML_PAGE = """
<!DOCTYPE html>
<html>
  <head>
    <title>ESP32 Tracker</title>
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
    <script>
      let map;
      let marker;

      async function updateMarker() {
        const response = await fetch('/coords');
        const data = await response.json();

        const pos = { lat: data.lat, lng: data.lon };
        marker.setPosition(pos);
        map.panTo(pos);
      }

      function initMap() {
        map = new google.maps.Map(document.getElementById("map"), {
          zoom: 5,
          center: { lat: 20.5937, lng: 78.9629 } // Center on India initially
        });

        marker = new google.maps.Marker({
          position: { lat: 20.5937, lng: 78.9629 },
          map: map,
          title: "ESP32 Location"
        });

        setInterval(updateMarker, 5000); // update every 5 sec
      }
    </script>
  </head>
  <body onload="initMap()">
    <h1>ESP32 Real-Time Location</h1>
    <div id="map" style="height: 500px; width: 100%;"></div>
  </body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_PAGE)

@app.route('/coords')
def coords():
    return jsonify(latest_coords)

if __name__ == '__main__':
    app.run(debug=True, use_reloader=False)
