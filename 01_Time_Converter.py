# 01_Time_Converter.py
# Converts integer minutes into "X hrs Y minutes" format

def minutes_to_hours_minutes(total_minutes: int) -> str:
    if total_minutes < 0:
        return "Minutes cannot be negative"

    hours = total_minutes // 60
    minutes = total_minutes % 60

    hour_text = f"{hours} hr" + ("s" if hours != 1 else "")
    minute_text = f"{minutes} minute" + ("s" if minutes != 1 else "")

    return f"{hour_text} {minute_text}"


# Testing the function
if __name__ == "__main__":
    test_values = [0, 5, 60, 75, 130, 200, 1440]

    for t in test_values:
        print(f"{t} minutes → {minutes_to_hours_minutes(t)}")
