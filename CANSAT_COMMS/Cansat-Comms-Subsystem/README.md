# 🚀 CANSAT Ground Station & Telemetry Communication System

A Python-based Ground Station developed as part of a CANSAT communication project to simulate telemetry exchange, command transmission, sensor monitoring, and real-time visualization between an onboard ESP32 and a Ground Control Station (GCS). The project progressively builds from basic serial communication to web-based control dashboards and real-time telemetry visualization.

---

# 📖 Overview

This project demonstrates the design and implementation of a modular communication framework for a CANSAT mission. Using **Python**, **PySerial**, **Flask**, and **Virtual COM Ports**, the system simulates communication between an ESP32 onboard computer and a ground station.

The project is divided into two development phases:

- **Week 1:** Fundamentals of serial communication, telemetry logging, and bidirectional command exchange.
- **Week 2:** Development of web-based monitoring and control interfaces for remote operation.

---

# ✨ Features

- Serial communication using UART protocol
- Ground station telemetry receiver
- ESP32 communication simulator
- Sensor data logging with timestamps
- Bidirectional command transmission
- Browser-based ESP32 control interface
- Live sensor dashboard
- Real-time GPS/object tracking framework
- Modular architecture for future hardware integration

---

# 📂 Project Structure

```text
CANSAT-Communication/
│
├── Week1/
│   ├── 1-receiver_script.py
│   ├── 2-sender_script.py
│   ├── 2-data_logger.py
│   ├── 3-command_sender.py
│   ├── 3-esp32_simulator.py
│   └── cansatdata.csv
│
└── Week2/
    ├── Device Control via Web Interface/
    │   ├── app.py
    │   └── esp32_simulator.py
    │
    ├── Live Sensor Data Dashboard/
    │   ├── app.py
    │   └── esp32_simulation.py
    │
    └── Real-Time Object Tracking/
        ├── app.py
        └── esp32_simulation.py
```

---

# ⚙️ Workflow

## Week 1 – Serial Communication Foundation

### 1. Serial Communication

- Established UART communication between two virtual COM ports using **PySerial**.
- Developed sender and receiver scripts to simulate telemetry exchange between an ESP32 and the ground station.

### 2. Telemetry Data Logging

- Received telemetry packets through the serial interface.
- Logged incoming sensor values with timestamps.
- Stored telemetry in CSV format for post-processing and analysis.

### 3. Bidirectional Command Communication

- Developed a command interface capable of sending ON/OFF commands.
- Simulated ESP32 responses.
- Verified reliable two-way communication between the Ground Control Station and the onboard system.

---

## Week 2 – Ground Station Applications

### 🌐 Device Control via Web Interface

A Flask web application was developed to remotely control the simulated ESP32.

**Workflow:**

```
User
   │
   ▼
Flask Web Interface
   │
   ▼
PySerial (UART)
   │
   ▼
ESP32 Simulator
   │
   ▼
Response to Browser
```

**Features**

- Browser-based ON/OFF controls
- Real-time device status updates
- Serial communication backend

---

### 📊 Live Sensor Data Dashboard

A real-time telemetry dashboard continuously receives sensor values from the ESP32 simulator and updates the browser without requiring page refreshes.

**Workflow:**

```
ESP32 Simulator
      │
      ▼
Serial Communication
      │
      ▼
Flask Backend
      │
      ▼
REST API
      │
      ▼
Live Dashboard
```

**Features**

- Live telemetry monitoring
- Automatic sensor updates
- Temperature visualization
- Background serial reader thread

---

### 📍 Real-Time Object Tracking

Developed a GPS telemetry framework capable of receiving latitude and longitude coordinates from the ESP32 simulator and displaying them through a web interface.

**Workflow:**

```
ESP32 Simulator
      │
      ▼
Serial Communication
      │
      ▼
Flask Backend
      │
      ▼
Coordinate Parsing
      │
      ▼
Web Interface
```

**Features**

- GPS coordinate transmission
- Background serial listener
- Live position updates
- Foundation for Google Maps integration

---

# 🛠️ Technologies Used

| Category | Technologies |
|-----------|--------------|
| Programming Language | Python |
| Serial Communication | PySerial, UART |
| Backend | Flask |
| Frontend | HTML, CSS, JavaScript |
| Data Logging | CSV |
| Data Processing | JSON, Threading |
| Hardware Simulation | ESP32 Simulator |
| Communication | Virtual COM Ports |
| Mapping | Google Maps API *(planned)* |
| Development Tools | VS Code, Git |

---

# 🏗️ System Architecture

```text
                 Ground Control Station

        +-----------------------------+
        |      Flask Web Server       |
        +-------------+---------------+
                      |
                PySerial (UART)
                      |
             Virtual COM Ports
                      |
        +-------------+---------------+
        |      ESP32 Simulator        |
        +-------------+---------------+
                      |
        Telemetry / Commands / GPS
```

---

# 🚀 Future Improvements

- Integrate with a physical ESP32-based CANSAT
- Support LoRa-based communication
- Interactive telemetry graphs
- Live GPS visualization using Google Maps
- Multi-sensor telemetry dashboard
- Mission replay using recorded telemetry
- Cloud-based data storage
- Desktop Ground Control Station application

---

# 👨‍💻 Author

**Karan Pote**

Developed as part of a CANSAT communication project to explore **embedded communication**, **ground station software**, **telemetry systems**, and **real-time monitoring** for aerospace applications.
