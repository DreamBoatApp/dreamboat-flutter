from PIL import Image
import os

source_path = r"C:/Users/guney/.gemini/antigravity/brain/f01312ca-9265-40ac-94b2-f350c57ee103/uploaded_media_1769681325200.jpg"
target_path = r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\db_logo_ios_sq_v2.png"

try:
    with Image.open(source_path) as img:
        # Resize to exactly 1024x1024 to meet iOS standards
        img = img.resize((1024, 1024), Image.Resampling.LANCZOS)
        
        # Save as PNG
        img.save(target_path, "PNG")
        print(f"Successfully saved 1024x1024 icon to {target_path}")
except Exception as e:
    print(f"Error processing image: {e}")
