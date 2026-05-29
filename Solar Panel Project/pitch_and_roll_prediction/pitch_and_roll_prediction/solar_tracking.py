import numpy as np
import pandas as pd
from datetime import datetime, timedelta

latitude = 15.0

def solar_declination(day):
    return 23.44 * np.sin(np.deg2rad((360/365) * (day - 81)))

def solar_hour_angle(hour):
    return 15 * (hour - 12)

def solar_position(day, hour):
    decl = solar_declination(day)
    hra = solar_hour_angle(hour)

    lat_rad = np.deg2rad(latitude)
    decl_rad = np.deg2rad(decl)
    hra_rad = np.deg2rad(hra)

    elevation = np.arcsin(
        np.sin(lat_rad) * np.sin(decl_rad) +
        np.cos(lat_rad) * np.cos(decl_rad) * np.cos(hra_rad)
    )

    azimuth = np.arctan2(
        -np.sin(hra_rad),
        np.tan(decl_rad) * np.cos(lat_rad) -
        np.sin(lat_rad) * np.cos(hra_rad)
    )

    pitch = np.rad2deg(elevation)
    roll = np.rad2deg(azimuth)

    return pitch, roll

start_date = datetime(2026, 1, 1)
data = []

for day_offset in range(365):
    current_date = start_date + timedelta(days=day_offset)

    day_of_year = current_date.timetuple().tm_yday
    month = current_date.month
    day_of_month = current_date.day

    # Week reset inside each month
    week_of_month = ((day_of_month - 1) // 7) + 1

    for hour in range(24):
        pitch, roll = solar_position(day_of_year, hour)

        data.append([
            month,
            week_of_month,
            day_of_year,
            hour,
            pitch,
            roll
        ])

df = pd.DataFrame(data, columns=[
    "month",
    "week_of_month",
    "day_of_year",
    "hour",
    "pitch",
    "roll"
])

df.to_csv("south_goa_hourly_tracking.csv", index=False)

print("Dataset generated with month-wise week reset.")
