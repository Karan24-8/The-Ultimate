#include <Servo.h>
#include <Wire.h>
#include <Adafruit_INA219.h>

Servo horizontalServo;
Servo verticalServo;

Adafruit_INA219 ina219;

int originH = 80;
int originV = 83;

int targetH = originH;
int targetV = originV;

int currentH = originH;
int currentV = originV;

void setup() {

  horizontalServo.attach(9);
  verticalServo.attach(10);

  Serial.begin(9600);

  if (!ina219.begin()) {
    Serial.println("INA219 not detected");
    while (1);
  }

  horizontalServo.write(originH);
  verticalServo.write(originV);
}

void loop() {

  // -------- CONTINUOUS SENSOR READINGS --------
  float busVoltage = ina219.getBusVoltage_V();
  float current = ina219.getCurrent_mA();
  float power = ina219.getPower_mW();

  Serial.println(power);

  // -------- CHECK USER INPUT --------
  if (Serial.available() > 1) {

    int inputH = Serial.parseInt(); //pitch 0 is normal
    int inputV = Serial.parseInt(); //roll 0 is west

    // Convert relative input to real30  servo angles
    targetH = originH + (inputH - 90);
    targetV = originV + (inputV - 90);

    targetH = constrain(targetH, 35, 150);
    targetV = constrain(targetV, 35, 150);
  }

  // -------- SMOOTH MOVEMENT --------

  if (currentH < targetH) currentH++;
  else if (currentH > targetH) currentH--;

  if (currentV < targetV) currentV++;
  else if (currentV > targetV) currentV--;

  horizontalServo.write(currentH);
  verticalServo.write(currentV);

  delay(5);
}