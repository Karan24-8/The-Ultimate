# ☀️ AI-Based Solar Panel Digital Twin & Autonomous Sun Tracking System

An AI-powered solar tracking system that predicts the sun's position using a machine learning model and automatically orients a dual-axis solar panel using servo motors controlled by an Arduino. The system also monitors real-time electrical power generation through an INA219 current sensor, creating a digital twin for intelligent solar energy optimization.

---

# 📖 Overview

Traditional solar panels remain fixed throughout the day, reducing their energy harvesting efficiency as the sun changes position. This project addresses that problem by combining **solar position modeling**, **machine learning**, and **embedded control** to automatically orient a dual-axis solar panel toward the sun.

The project consists of two major components:

- **Digital Twin & Machine Learning Module (Python)**
- **Embedded Motor Control System (Arduino)**

The AI model predicts the optimal **pitch** and **roll** angles of the solar panel using only the day of the year and hour of the day. These predicted angles are transmitted to an Arduino, which smoothly controls two servo motors while continuously monitoring the generated electrical power.

---

# ✨ Features

- AI-based prediction of solar panel orientation
- Dual-axis autonomous solar tracking
- Digital twin for solar trajectory prediction
- Smooth servo motor control
- Real-time power monitoring using INA219
- Synthetic dataset generation using solar geometry
- Neural network trained with TensorFlow/Keras
- Modular architecture for hardware deployment

---

# 📂 Project Structure

```text
Solar-Panel-Project/
│
├── Motor_and_Sensor_Solar_Panel/
│   └── Motor_and_Sensor_Solar_Panel.ino
│
├── pitch_and_roll_prediction/
│   ├── Generated Power Output.xlsx
│   ├── predict_pitch_roll.py
│   ├── requirements.txt
│   ├── solar_pitch_roll_model.keras
│   ├── solar_pitch_roll_model.h5
│   ├── solar_tracking.py
│   ├── south_goa_hourly_tracking.csv
│   └── train_model.py
│
└── Solar Panel Connections.png
```

---

# ⚙️ Workflow

## Step 1 — Solar Position Dataset Generation

A Python program models the sun's apparent movement throughout the year using solar geometry equations.

Inputs:

- Day of the Year
- Hour of the Day
- Latitude (South Goa)

Outputs:

- Solar Pitch
- Solar Roll

The generated dataset contains hourly solar positions for an entire year and is saved as:

```
south_goa_hourly_tracking.csv
```

---

## Step 2 — Machine Learning Model Training

The generated dataset is used to train a neural network capable of predicting the optimal panel orientation.

### Feature Engineering

To preserve the cyclic nature of time,

- Day → Sin/Cos Encoding
- Hour → Sin/Cos Encoding

The input vector becomes:

```
[
 day_sin,
 day_cos,
 hour_sin,
 hour_cos
]
```

The neural network predicts:

- Pitch Angle
- Roll Angle

The trained model is exported as:

```
solar_pitch_roll_model.keras
```

---

## Step 3 — Solar Angle Prediction

The prediction script loads the trained model.

User provides:

- Day of Year
- Hour

The model predicts:

- Pitch
- Roll

These values represent the ideal orientation of the solar panel for maximum sunlight exposure.

---

## Step 4 — Arduino-Based Solar Tracking

The Arduino receives the predicted pitch and roll values through serial communication.

The embedded controller:

- Converts predicted values into servo angles
- Smoothly rotates two servo motors
- Constrains movement within mechanical limits
- Prevents sudden motor movements

The two servos control:

- Horizontal Rotation
- Vertical Rotation

forming a complete dual-axis tracking mechanism.

---

## Step 5 — Power Monitoring

An INA219 current sensor continuously measures:

- Bus Voltage
- Current
- Power Output

The measured power is transmitted through the serial port for monitoring and performance evaluation.

This enables comparison between predicted orientation and actual generated power.

---

# 🏗️ System Architecture

```text
            Solar Geometry Model
                     │
                     ▼
         Dataset Generation (CSV)
                     │
                     ▼
          TensorFlow Neural Network
                     │
                     ▼
      Predicted Pitch & Roll Angles
                     │
             Serial Communication
                     │
                     ▼
              Arduino UNO
                     │
      ┌──────────────┴──────────────┐
      ▼                             ▼
Horizontal Servo             Vertical Servo
      │                             │
      └──────────────┬──────────────┘
                     ▼
             Solar Panel Orientation
                     │
                     ▼
          INA219 Power Sensor
                     │
                     ▼
          Real-Time Power Monitoring
```

---

# 🛠️ Technologies Used

| Category | Technologies |
|-----------|--------------|
| Programming Languages | Python, Arduino C++ |
| Machine Learning | TensorFlow, Keras |
| Data Processing | NumPy, Pandas |
| Model Evaluation | Scikit-Learn |
| Embedded Systems | Arduino UNO |
| Sensors | INA219 Current & Power Sensor |
| Actuators | Servo Motors |
| Communication | Serial Communication (UART) |
| Dataset Storage | CSV, Excel |
| Development Tools | VS Code, Arduino IDE |

---

# 📊 Machine Learning Pipeline

```
Solar Geometry
        │
        ▼
Dataset Generation
        │
        ▼
Feature Engineering
(Sin/Cos Encoding)
        │
        ▼
Neural Network Training
        │
        ▼
Pitch & Roll Prediction
        │
        ▼
Arduino Controller
        │
        ▼
Servo Motor Movement
```

---

# 🚀 Future Improvements

- Live weather-aware tracking using cloud weather APIs
- Reinforcement Learning for adaptive solar optimization
- Real-time IoT dashboard for remote monitoring
- Automatic calibration using light sensors
- MQTT-based communication
- Battery charging optimization
- Multi-panel distributed tracking system
- Integration with photovoltaic efficiency prediction models

---

# 📷 Hardware Components

- Arduino UNO
- Two Servo Motors
- INA219 Voltage & Current Sensor
- Solar Panel
- Connecting Wires
- Power Supply

Refer to:

```
Solar Panel Connections.png
```

for the complete hardware wiring.

---

# 👨‍💻 Author

**Karan Pote**

This project was developed to explore the integration of **Machine Learning**, **Digital Twin Technology**, **Embedded Systems**, and **Renewable Energy** for intelligent autonomous solar tracking and energy optimization.
