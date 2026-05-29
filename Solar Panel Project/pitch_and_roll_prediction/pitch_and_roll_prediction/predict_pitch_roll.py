import numpy as np
import tensorflow as tf

# Load trained model
model = tf.keras.models.load_model("solar_pitch_roll_model.keras")

# User input
day = int(input("Enter day_of_year (1-365): "))
hour = int(input("Enter hour (0-23): "))

# ===== SAME CYCLIC ENCODING =====

day_sin = np.sin(2 * np.pi * day / 365)
day_cos = np.cos(2 * np.pi * day / 365)

hour_sin = np.sin(2 * np.pi * hour / 24)
hour_cos = np.cos(2 * np.pi * hour / 24)

input_data = np.array([[day_sin, day_cos, hour_sin, hour_cos]])

# Predict
prediction = model.predict(input_data)

pitch = prediction[0][0]
roll = prediction[0][1]

print("\nPredicted Values:")
print("Pitch:", pitch)
print("Roll :", roll)
