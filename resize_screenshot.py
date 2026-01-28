from PIL import Image
import os

source_path = r"C:/Users/guney/.gemini/antigravity/brain/28365488-1e9b-4f2b-9c66-fd66c48af52f/uploaded_media_0_1769615014229.jpg"
target_path = r"C:/Users/guney/.gemini/antigravity/brain/28365488-1e9b-4f2b-9c66-fd66c48af52f/iap_screenshot_fixed.png"

# iPhone 6.7" Display (1290 x 2796)
target_size = (1290, 2796)

try:
    with Image.open(source_path) as img:
        # Resize using LANCZOS for high quality
        resized_img = img.resize(target_size, Image.Resampling.LANCZOS)
        resized_img.save(target_path, "PNG")
        print(f"Successfully resized to {target_size} and saved to {target_path}")
except Exception as e:
    print(f"Error resizing image: {e}")
