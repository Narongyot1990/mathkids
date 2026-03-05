"""
Test script for Gemini API to see actual response format
This will help design the optimal UI for solution display
"""

from google import genai
from PIL import Image
import os
import json

GEMINI_API_KEY = "AIzaSyDTSXm0WpXt2SPPhKZzhxFCHWrI0iJB6YY"
client = genai.Client(api_key=GEMINI_API_KEY)

def test_gemini_response(image_path: str) -> dict:
    """Test Gemini API with a sample math problem image"""

    if not os.path.exists(image_path):
        print(f"❌ ไม่พบไฟล์: {image_path}")
        print("📝 กรุณาสร้างรูปโจทย์คณิตศาสตร์ตัวอย่าง (เช่น เขียนบนกระดาษแล้วถ่ายรูป)")
        print("   ตัวอย่างโจทย์: x^2 + 5x + 6 = 0")
        return {"success": False, "error": f"ไม่พบไฟล์: {image_path}"}

    try:
        image = Image.open(image_path)
        print(f"📸 กำลังส่งรูป {image_path} ไปวิเคราะห์...")
        print(f"   ขนาดรูป: {image.size}")

        # Thai prompt for math/physics problems
        prompt = """
You are an expert Mathematics and Physics tutor. Your goal is to help students understand problems by providing clear, step-by-step solutions. You must use LaTeX format for all mathematical equations (e.g., $x^2 + 2x + 1 = 0$). Always respond in the Thai language.

Please analyze the attached image containing a math or physics problem.

Task:
1. Transcript: Extract the text/numbers from the image exactly as they appear.
2. Identify: Briefly state the topic (e.g., Calculus, Newton's Laws).
3. Solution: Solve the problem step-by-step. Explain the logic behind each step.
4. Final Answer: Clearly state the final result.

Format the output nicely using Markdown.
"""

        print("\n⏳ รอ AI วิเคราะห์... (อาจใช้เวลา 5-10 วินาที)\n")

        response = client.models.generate_content(
            model='gemini-2.0-flash-exp',
            contents=[prompt, image]
        )

        if response.text:
            print("=" * 80)
            print("✅ AI ตอบกลับสำเร็จ!")
            print("=" * 80)
            print("\n📄 RESPONSE TEXT:\n")
            print(response.text)
            print("\n" + "=" * 80)

            # Analyze response structure
            print("\n📊 การวิเคราะห์ Response:")
            print(f"   • ความยาว: {len(response.text)} ตัวอักษร")
            print(f"   • จำนวนบรรทัด: {response.text.count(chr(10)) + 1}")
            print(f"   • มี Markdown headers (#): {response.text.count('#')}")
            print(f"   • มี LaTeX equations ($): {response.text.count('$')}")
            print(f"   • มี Code blocks (```): {response.text.count('```')}")
            print(f"   • มี Lists (-): {response.text.count('\n-')}")
            print(f"   • มี Numbered lists: {sum(1 for line in response.text.split('\n') if line.strip() and line.strip()[0].isdigit() and '.' in line[:3])}")

            # Save to file for reference
            with open('gemini_response_sample.txt', 'w', encoding='utf-8') as f:
                f.write(response.text)
            print(f"\n💾 บันทึก response ไว้ที่: gemini_response_sample.txt")

            # Save JSON structure
            response_data = {
                "success": True,
                "answer": response.text,
                "metadata": {
                    "length": len(response.text),
                    "lines": response.text.count('\n') + 1,
                    "has_headers": response.text.count('#') > 0,
                    "has_latex": response.text.count('$') > 0,
                    "has_code_blocks": response.text.count('```') > 0,
                    "has_lists": response.text.count('\n-') > 0
                }
            }

            with open('gemini_response_sample.json', 'w', encoding='utf-8') as f:
                json.dump(response_data, f, ensure_ascii=False, indent=2)
            print(f"💾 บันทึก JSON structure ไว้ที่: gemini_response_sample.json")

            return response_data
        else:
            print("❌ AI ไม่ตอบกลับ")
            return {"success": False, "error": "AI ไม่ตอบกลับ"}

    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        return {"success": False, "error": str(e)}

if __name__ == "__main__":
    print("=" * 80)
    print("🧪 Gemini API Test Script")
    print("=" * 80)
    print("\n📌 วัตถุประสงค์: ทดสอบ Gemini API เพื่อดูรูปแบบ response จริง")
    print("   แล้วนำไปออกแบบ UI ที่เหมาะสมสำหรับแสดงคำตอบ\n")

    # Test with sample image
    # You can create a simple math problem image or use any existing one
    test_images = [
        "test_image.png",
        "test_image.jpg",
        "image.png",
        "image.jpg",
    ]

    image_found = False
    for img in test_images:
        if os.path.exists(img):
            print(f"✅ พบรูปภาพทดสอบ: {img}\n")
            result = test_gemini_response(img)
            image_found = True
            break

    if not image_found:
        print("📝 วิธีการทดสอบ:")
        print("   1. สร้างรูปโจทย์คณิตศาสตร์ (เขียนบนกระดาษ/หน้าจอแล้วถ่ายรูป)")
        print("   2. บันทึกเป็น 'test_image.png' หรือ 'test_image.jpg'")
        print("   3. วางไฟล์ในโฟลเดอร์เดียวกับสคริปต์นี้")
        print("   4. รันสคริปต์อีกครั้ง")
        print("\n   ตัวอย่างโจทย์:")
        print("   • ง่าย: 2 + 2 = ?")
        print("   • ปานกลาง: x^2 + 5x + 6 = 0")
        print("   • ยาก: โจทย์แคลคูลัสหรือฟิสิกส์")

        # Alternative: Create a simple text image
        print("\n💡 หรือจะสร้างรูปทดสอบด้วย Python:")
        print("   ติดตั้ง: pip install pillow")
        print("   แล้วรันโค้ดนี้:\n")
        print("""
from PIL import Image, ImageDraw, ImageFont

# Create white image
img = Image.new('RGB', (800, 400), color='white')
draw = ImageDraw.Draw(img)

# Draw math problem
try:
    font = ImageFont.truetype("arial.ttf", 60)
except:
    font = ImageFont.load_default()

text = "x² + 5x + 6 = 0"
draw.text((50, 150), text, fill='black', font=font)

img.save('test_image.png')
print("✅ สร้าง test_image.png สำเร็จ!")
""")
