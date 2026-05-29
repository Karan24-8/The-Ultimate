```mermaid
graph TD
    %% Entities
    USERS[USERS]
    USER_PROFILE[USER_PROFILE]
    CONSULTATIONS[CONSULTATIONS]
    FOODS[FOODS]
    RECIPES[RECIPES]
    EXERCISES[EXERCISES]
    DIET_LOGS[DIET_LOGS]
    WORKOUT_LOGS[WORKOUT_LOGS]
    RECIPE_FOODS[RECIPE_FOODS]
    DIET_PLANS[DIET_PLANS]
    WORKOUT_PLANS[WORKOUT_PLANS]
    GOALS[GOALS]
    WORKOUT_PLAN_EXERCISES[WORKOUT_PLAN_EXERCISES]
    PROGRESS_TRACKING[PROGRESS_TRACKING]

    %% Relationships
    HAS{Has}
    SETS{Sets}
    CREATES{Creates}
    REQUESTS{Requests}
    RECIEVES_AS_EXPERT{Recieves_as_expert}
    TRACKS{Tracks}
    CREATES_AS_ADMIN{Creates_as_admin}
    LOGGED_IN{Logged_in}
    INCLUDES{Includes}
    USED_IN{Used_in}
    CONTAINS{Contains}
    SUPPORTS{Supports}
    MONITORS{Monitors}

    %% Attributes (Ovals)
    A1(["id"])
    A2(["email"])
    A3(["password_hash"])
    A4(["name"])
    A5(["role"])
    A6(["phone"])
    A7(["created_at"])
    A8(["updated_at"])
    A9(["is_active"])
    A10(["specialization"])
    A11(["experience_years"])
    A12(["rating"])
    
    B1(["id"])
    B2(["user_id"])
    B3(["age"])
    B4(["gender"])
    B5(["height_cm"])
    B6(["current_weight_kg"])
    B7(["activity_level"])
    B8(["medical_conditions"])
    B9(["allergies"])
    B10(["created_at"])
    B11(["updated_at"])

    C1(["id"])
    C2(["user_id"])
    C3(["expert_id"])
    C4(["subject"])
    C5(["message"])
    C6(["preferred_date"])
    C7(["preferred_time"])
    C8(["status"])
    C9(["expert_response"])
    C10(["response_date"])
    C11(["consultation_fee"])
    C12(["created_at"])
    C13(["updated_at"])

    D1(["id"])
    D2(["name"])
    D3(["category"])
    D4(["calories_per_100g"])
    D5(["protein_per_100g"])
    D6(["carbs_per_100g"])
    D7(["fats_per_100g"])
    D8(["fiber_per_100g"])
    D9(["serving_size"])
    D10(["is_verfied"])
    D11(["created_by_admin_id"])
    D12(["created_at"])
    D13(["updated_at"])

    E1(["id"])
    E2(["name"])
    E3(["description"])
    E4(["preparation_time_mins"])
    E5(["servings"])
    E6(["instructions"])
    E7(["total_calories"])
    E8(["total_proteins"])
    E9(["total_carbs"])
    E10(["total_fats"])
    E11(["created_by_admin_id"])
    E12(["created_at"])
    E13(["updated_at"])

    F1(["id"])
    F2(["name"])
    F3(["category"])
    F4(["difficulty_level"])
    F5(["calories_per_hour"])
    F6(["equipment_needed"])
    F7(["description"])
    F8(["muscle_groups"])
    F9(["created_by_admin_id"])
    F10(["created_at"])
    F11(["updated_at"])

    G1(["id"])
    G2(["user_id"])
    G3(["food_id"])
    G4(["recipe_id"])
    G5(["log_date"])
    G6(["meal_type"])
    G7(["quantity_g"])
    G8(["calories_consumed"])
    G9(["protein_consumed"])
    G10(["carbs_consumed"])
    G11(["fats_consumed"])
    G12(["notes"])
    G13(["created_at"])

    H1(["id"])
    H2(["user_id"])
    H3(["exercise_id"])
    H4(["log_date"])
    H5(["duration_minutes"])
    H6(["sets"])
    H7(["reps"])
    H8(["weight_kg"])
    H9(["distance_km"])
    H10(["calories_burned"])
    H11(["notes"])
    H12(["created_at"])

    I1(["id"])
    I2(["recipe_id"])
    I3(["food_id"])
    I4(["quantity_g"])
    I5(["order_number"])

    J1(["id"])
    J2(["name"])
    J3(["description"])
    J4(["plan_type"])
    J5(["duration_days"])
    J6(["daily_calories"])
    J7(["daily_protein"])
    J8(["daily_carbs"])
    J9(["daily_fats"])
    J10(["created_by_admin_id"])
    J11(["created_at"])
    J12(["updated_at"])

    K1(["id"])
    K2(["name"])
    K3(["description"])
    K4(["plan_type"])
    K5(["focus"])
    K6(["duration_weeks"])
    K7(["workouts_per_week"])
    K8(["created_by_admin_id"])
    K9(["created_at"])
    K10(["updated_at"])

    L1(["id"])
    L2(["user_id"])
    L3(["goal_type"])
    L4(["target_weight_kg"])
    L5(["starting_weight_kg"])
    L6(["duration_weeks"])
    L7(["start_date"])
    L8(["target_date"])
    L9(["daily_calorie_target"])
    L10(["protein_target_g"])
    L11(["carbs_target_g"])
    L12(["fats_target_g"])
    L13(["status"])
    L14(["created_at"])
    L15(["updated_at"])

    M1(["id"])
    M2(["workout_plan_id"])
    M3(["exercise_id"])
    M4(["day_number"])
    M5(["sets"])
    M6(["reps"])
    M7(["duration_minutes"])
    M8(["instructions"])
    M9(["order_number"])

    N1(["id"])
    N2(["user_id"])
    N3(["goal_id"])
    N4(["tracking_id"])
    N5(["current_weight_kg"])
    N6(["body_fat_percentage"])
    N7(["muscle_mass_kg"])
    N8(["waist_cm"])
    N9(["chest_cm"])
    N10(["arms_cm"])
    N11(["thighs_cm"])
    N12(["progress_photos"])
    N13(["notes"])
    N14(["created_at"])

    %% Connections for Attributes
    A1 --- USERS
    A2 --- USERS
    A3 --- USERS
    A4 --- USERS
    A5 --- USERS
    A6 --- USERS
    A7 --- USERS
    A8 --- USERS
    A9 --- USERS
    A10 --- USERS
    A11--- USERS
    A12 --- USERS

    B1 --- USER_PROFILE
    B2 --- USER_PROFILE
    B3 --- USER_PROFILE
    B4 --- USER_PROFILE
    B5 --- USER_PROFILE
    B6 --- USER_PROFILE
    B7 --- USER_PROFILE
    B8 --- USER_PROFILE
    B9 --- USER_PROFILE
    B10 --- USER_PROFILE
    B11 --- USER_PROFILE

    C1 --- CONSULTATIONS
    C2 --- CONSULTATIONS
    C3 --- CONSULTATIONS
    C4 --- CONSULTATIONS
    C5 --- CONSULTATIONS
    C6 --- CONSULTATIONS
    C7 --- CONSULTATIONS
    C8 --- CONSULTATIONS
    C9 --- CONSULTATIONS
    C10 --- CONSULTATIONS
    C11 --- CONSULTATIONS
    C12 --- CONSULTATIONS
    C13 --- CONSULTATIONS

    D1 --- FOODS
    D2 --- FOODS
    D3 --- FOODS
    D4 --- FOODS
    D5 --- FOODS
    D6 --- FOODS
    D7 --- FOODS
    D8 --- FOODS
    D9 --- FOODS
    D10 --- FOODS
    D11 --- FOODS
    D12 --- FOODS
    D13 --- FOODS

    E1 --- RECIPES
    E2 --- RECIPES
    E3 --- RECIPES
    E4 --- RECIPES
    E5 --- RECIPES
    E6 --- RECIPES
    E7 --- RECIPES
    E8 --- RECIPES
    E9 --- RECIPES
    E10 --- RECIPES
    E11 --- RECIPES
    E12 --- RECIPES
    E13 --- RECIPES

    F1 --- EXERCISES
    F2 --- EXERCISES
    F3 --- EXERCISES
    F4 --- EXERCISES
    F5 --- EXERCISES
    F6 --- EXERCISES
    F7 --- EXERCISES
    F8 --- EXERCISES
    F9 --- EXERCISES
    F10 --- EXERCISES
    F11 --- EXERCISES

    G1 --- DIET_LOGS
    G2 --- DIET_LOGS
    G3 --- DIET_LOGS
    G4 --- DIET_LOGS
    G5 --- DIET_LOGS
    G6 --- DIET_LOGS
    G7 --- DIET_LOGS
    G8 --- DIET_LOGS
    G9 --- DIET_LOGS
    G10 --- DIET_LOGS
    G11 --- DIET_LOGS
    G12 --- DIET_LOGS
    G13 --- DIET_LOGS

    H1 --- WORKOUT_LOGS
    H2 --- WORKOUT_LOGS
    H3 --- WORKOUT_LOGS
    H4 --- WORKOUT_LOGS
    H5 --- WORKOUT_LOGS
    H6 --- WORKOUT_LOGS
    H7 --- WORKOUT_LOGS
    H8 --- WORKOUT_LOGS
    H9 --- WORKOUT_LOGS
    H10 --- WORKOUT_LOGS
    H11 --- WORKOUT_LOGS
    H12 --- WORKOUT_LOGS

    I1 --- RECIPE_FOODS
    I2 --- RECIPE_FOODS
    I3 --- RECIPE_FOODS
    I4 --- RECIPE_FOODS
    I5 --- RECIPE_FOODS

    J1 --- DIET_PLANS
    J2 --- DIET_PLANS
    J3 --- DIET_PLANS
    J4 --- DIET_PLANS
    J5 --- DIET_PLANS
    J6 --- DIET_PLANS
    J7 --- DIET_PLANS
    J8 --- DIET_PLANS
    J9 --- DIET_PLANS
    J10 --- DIET_PLANS
    J11 --- DIET_PLANS
    J12 --- DIET_PLANS

    K1 --- WORKOUT_PLANS
    K2 --- WORKOUT_PLANS
    K3 --- WORKOUT_PLANS
    K4 --- WORKOUT_PLANS
    K5 --- WORKOUT_PLANS
    K6 --- WORKOUT_PLANS
    K7 --- WORKOUT_PLANS
    K8 --- WORKOUT_PLANS
    K9 --- WORKOUT_PLANS
    K10 --- WORKOUT_PLANS

    L1 --- GOALS
    L2 --- GOALS
    L3 --- GOALS
    L4 --- GOALS
    L5 --- GOALS
    L6 --- GOALS
    L7 --- GOALS
    L8 --- GOALS
    L9 --- GOALS
    L10 --- GOALS
    L11 --- GOALS
    L12 --- GOALS
    L13 --- GOALS
    L14 --- GOALS
    L15 --- GOALS

    M1 --- WORKOUT_PLAN_EXERCISES
    M2 --- WORKOUT_PLAN_EXERCISES
    M3 --- WORKOUT_PLAN_EXERCISES
    M4 --- WORKOUT_PLAN_EXERCISES
    M5 --- WORKOUT_PLAN_EXERCISES
    M6 --- WORKOUT_PLAN_EXERCISES
    M7 --- WORKOUT_PLAN_EXERCISES
    M8 --- WORKOUT_PLAN_EXERCISES
    M9 --- WORKOUT_PLAN_EXERCISES

    N1 --- PROGRESS_TRACKING
    N2 --- PROGRESS_TRACKING
    N3 --- PROGRESS_TRACKING
    N4 --- PROGRESS_TRACKING
    N5 --- PROGRESS_TRACKING
    N6 --- PROGRESS_TRACKING
    N7 --- PROGRESS_TRACKING
    N8 --- PROGRESS_TRACKING
    N9 --- PROGRESS_TRACKING
    N10 --- PROGRESS_TRACKING
    N11 --- PROGRESS_TRACKING
    N12 --- PROGRESS_TRACKING
    N13 --- PROGRESS_TRACKING
    N14 --- PROGRESS_TRACKING

    %% Connections for Entities
    USERS --- HAS --- USER_PROFILE
    USERS --- SETS --- GOALS
    USERS --- CREATES --- DIET_LOGS
    USERS --- CREATES --- WORKOUT_LOGS
    USERS --- TRACKS --- PROGRESS_TRACKING
    USERS --- CREATES_AS_ADMIN --- FOODS
    USERS --- CREATES_AS_ADMIN --- RECIPES
    USERS --- CREATES_AS_ADMIN --- EXERCISES
    USERS --- CREATES_AS_ADMIN --- DIET_PLANS
    USERS --- CREATES_AS_ADMIN --- WORKOUT_PLANS
    USERS --- REQUESTS --- CONSULTATIONS
    USERS --- RECIEVES_AS_EXPERT --- CONSULTATIONS

    FOODS --- LOGGED_IN --- DIET_LOGS
    FOODS --- INCLUDES --- DIET_PLANS
    FOODS --- USED_IN --- RECIPE_FOODS

    RECIPES --- CONTAINS --- RECIPE_FOODS
    RECIPES --- INCLUDES --- DIET_PLANS

    WORKOUT_PLANS --- CONTAINS --- WORKOUT_PLAN_EXERCISES

    EXERCISES --- LOGGED_IN --- WORKOUT_LOGS
    EXERCISES --- INCLUDES --- WORKOUT_PLANS
    EXERCISES --- USED_IN --- WORKOUT_PLAN_EXERCISES

    GOALS --- SUPPORTS --- DIET_PLANS
    GOALS --- SUPPORTS --- WORKOUT_PLANS
    GOALS --- MONITORS --- PROGRESS_TRACKING

    %% Styling
    style USERS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style USER_PROFILE fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style CONSULTATIONS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style FOODS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style RECIPES fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style EXERCISES fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style DIET_LOGS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style WORKOUT_LOGS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style RECIPE_FOODS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style DIET_PLANS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style WORKOUT_PLANS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style GOALS fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style WORKOUT_PLAN_EXERCISES fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000
    style PROGRESS_TRACKING fill:#57b956,stroke:#000000,stroke-width:3px,color:#000000

    style HAS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style SETS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style CREATES fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style REQUESTS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style RECIEVES_AS_EXPERT fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style TRACKS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style CREATES_AS_ADMIN fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style LOGGED_IN fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style INCLUDES fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style USED_IN fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style CONTAINS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style SUPPORTS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000
    style MONITORS fill:#f2c80f,stroke:#000000,stroke-width:1px,color:#000000

    style A1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style A12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style B1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style B11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style C1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style C13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style D1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style D13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style E1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style E13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style F1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style F11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style G1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style G13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style H1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style H12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style I1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style I2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style I3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style I4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style I5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style J1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style J12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style K1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style K10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style L1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L14 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style L15 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style M1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style M9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000

    style N1 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N2 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N3 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N4 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N5 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N6 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N7 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N8 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N9 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N10 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N11 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N12 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N13 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
    style N14 fill:#01BBAA,stroke:#000000,stroke-width:2px,color:#000000
```