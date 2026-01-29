import os
from PIL import Image

# Files to convert to WebP
files = [
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_dreamcatcher_bg.png",
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_egypt_bg.png",
    r"c:\Users\guney\.gemini\antigravity\playground\shimmering-singularity\dream_boat_mobile\assets\images\guide_tibet_bg.png"
]

target_width = 1080 # Increased from 800 for better quality on tablets

for file_path in files:
    try:
        with Image.open(file_path) as img:
            # Create new filename with .webp extension
            new_file_path = os.path.splitext(file_path)[0] + ".webp"
            
            # Calculate new height to maintain aspect ratio
            width_percent = (target_width / float(img.size[0]))
            h_size = int((float(img.size[1]) * float(width_percent)))
            
            # Resize
            img = img.resize((target_width, h_size), Image.Resampling.LANCZOS)
            
            # Save as WebP (lossless=False for better compression, quality=80 is usually visually identical)
            img.save(new_file_path, "WEBP", quality=80)
            print(f"Converted {file_path} -> {new_file_path}")
            
            # Optional: Remove original if successful? 
            # adhering to safety, we will NOT delete original yet, user can do it later or we update pubspec first.
    except Exception as e:
        print(f"Error converting {file_path}: {e}")
