"""
Create sample math problem images for testing Gemini API
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_test_image(problem_text, filename, problem_type="math"):
    """Create a test image with math/physics problem"""

    # Create white background
    width = 1200
    height = 800
    img = Image.new('RGB', (width, height), color='white')
    draw = ImageDraw.Draw(img)

    # Try to load a nice font, fallback to default
    try:
        title_font = ImageFont.truetype("arial.ttf", 48)
        text_font = ImageFont.truetype("arial.ttf", 36)
        small_font = ImageFont.truetype("arial.ttf", 28)
    except:
        try:
            title_font = ImageFont.truetype("Arial.ttf", 48)
            text_font = ImageFont.truetype("Arial.ttf", 36)
            small_font = ImageFont.truetype("Arial.ttf", 28)
        except:
            title_font = ImageFont.load_default()
            text_font = ImageFont.load_default()
            small_font = ImageFont.load_default()

    # Draw border
    draw.rectangle([20, 20, width-20, height-20], outline='black', width=3)

    # Draw title
    if problem_type == "math":
        title = "โจทย์คณิตศาสตร์"
        color = '#9B6BFF'
    else:
        title = "โจทย์ฟิสิกส์"
        color = '#5B9FFF'

    # Title background
    draw.rectangle([40, 40, width-40, 120], fill=color)
    draw.text((60, 60), title, fill='white', font=title_font)

    # Problem text
    y_position = 180
    lines = problem_text.split('\n')

    for line in lines:
        draw.text((60, y_position), line, fill='black', font=text_font)
        y_position += 60

    # Add instruction
    draw.text((60, height-100), "จงแก้โจทย์และแสดงวิธีทำ", fill='gray', font=small_font)

    # Save
    img.save(filename)
    print(f"✅ สร้างรูป: {filename}")

# Create multiple test images with various difficulty levels

# 1. Easy - Simple quadratic equation
create_test_image(
    "แก้สมการ:\n\nx² + 5x + 6 = 0",
    "test_image_easy.png",
    "math"
)

# 2. Medium - Quadratic formula application
create_test_image(
    "แก้สมการโดยใช้สูตร:\n\n2x² - 7x + 3 = 0",
    "test_image_medium.png",
    "math"
)

# 3. Hard - Calculus problem
create_test_image(
    "จงหาค่าอนุพันธ์:\n\nf(x) = 3x³ - 2x² + 5x - 7\n\nเมื่อ x = 2",
    "test_image_hard.png",
    "math"
)

# 4. Physics - Projectile motion
create_test_image(
    "ลูกบอลถูกยิงขึ้นจากพื้นด้วยความเร็ว\n\n20 m/s ทำมุม 45° กับแนวราบ\n\nจงหา:\n1. ระยะทางสูงสุด\n2. เวลาที่ใช้ในอากาศ\n\n(g = 10 m/s²)",
    "test_image_physics.png",
    "physics"
)

# 5. Complex - System of equations
create_test_image(
    "แก้ระบบสมการ:\n\n2x + 3y = 12\n\n5x - 2y = 4",
    "test_image_system.png",
    "math"
)

print("\n" + "=" * 60)
print("🎉 สร้างรูปทดสอบเสร็จสมบูรณ์!")
print("=" * 60)
print("\nรูปที่สร้าง:")
print("  1. test_image_easy.png - โจทย์ง่าย (สมการกำลังสอง)")
print("  2. test_image_medium.png - โจทย์ปานกลาง (ใช้สูตร)")
print("  3. test_image_hard.png - โจทย์ยาก (แคลคูลัส)")
print("  4. test_image_physics.png - โจทย์ฟิสิกส์ (การเคลื่อนที่แบบโปรเจกไทล์)")
print("  5. test_image_system.png - โจทย์ซับซ้อน (ระบบสมการ)")
print("\nใช้คำสั่ง: python test_gemini_api.py")
print("เพื่อทดสอบ API กับรูปเหล่านี้")
