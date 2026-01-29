import os
from PIL import Image

# Resize images to reduce size
files = [
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_dreamcatcher_bg.png",
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_egypt_bg.png",
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_tibet_bg.png"
]

target_width = 800

for file_path in files:
    try:
        with Image.open(file_path) as img:
            # Calculate new height to maintain aspect ratio
            width_percent = (target_width / float(img.size[0]))
            h_size = int((float(img.size[1]) * float(width_percent)))
            
            # Resize
            img = img.resize((target_width, h_size), Image.Resampling.LANCZOS)
            
            # Save (overwrite)
            img.save(file_path, optimize=True, quality=85)
            print(f"Resized {file_path}")
    except Exception as e:
        print(f"Error resizing {file_path}: {e}")
