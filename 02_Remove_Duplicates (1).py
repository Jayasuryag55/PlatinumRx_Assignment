# 02_Remove_Duplicates.py
# Removes duplicate characters while keeping original order

def remove_duplicate_chars(text: str) -> str:
    seen = set()
    result = []

    for char in text:
        if char not in seen:
            seen.add(char)
            result.append(char)

    return "".join(result)


# Testing the function
if __name__ == "__main__":
    samples = [
        "banana",
        "aabbcc",
        "hello world",
        "ABabAB",
        "",
        "mississippi"
    ]

    for s in samples:
        print(f"Input: {s} → Output: {remove_duplicate_chars(s)}")
