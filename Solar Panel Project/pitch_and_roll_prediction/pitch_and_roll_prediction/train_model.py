import pandas as pd
import numpy as np
import tensorflow as tf
from sklearn.model_selection import train_test_split

# Load dataset
df = pd.read_csv("south_goa_hourly_tracking.csv")

# ===== CYCLIC FEATURE ENGINEERING =====

day = df["day_of_year"].values
hour = df["hour"].values

day_sin = np.sin(2 * np.pi * day / 365)
day_cos = np.cos(2 * np.pi * day / 365)

hour_sin = np.sin(2 * np.pi * hour / 24)
hour_cos = np.cos(2 * np.pi * hour / 24)

# Final input matrix
X = np.column_stack((day_sin, day_cos, hour_sin, hour_cos))

# Targets
y = df[["pitch", "roll"]].values

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# ===== BUILD MODEL =====

model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation='relu', input_shape=(4,)),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(2)  # pitch, roll
])

model.compile(
    optimizer='adam',
    loss='mse',
    metrics=['mae']
)

# ===== TRAIN =====

model.fit(
    X_train, y_train,
    epochs=60,
    batch_size=32,
    validation_split=0.2,
    verbose=1
)

# ===== EVALUATE =====

loss, mae = model.evaluate(X_test, y_test)
print("\nTest MAE:", mae)

# ===== SAVE MODEL (modern format) =====
model.save("solar_pitch_roll_model.keras")

print("Model saved successfully.")
