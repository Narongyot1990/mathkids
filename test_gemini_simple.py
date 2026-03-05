"""
Simple Gemini API test using requests library (no special dependencies)
Tests with the physics problem image provided by user
"""

import base64
import json
import sys

try:
    import requests
except ImportError:
    print("❌ ต้องการ requests library")
    print("ติดตั้ง: pip install requests")
    sys.exit(1)

GEMINI_API_KEY = "AIzaSyDTSXm0WpXt2SPPhKZzhxFCHWrI0iJB6YY"
API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent"

# Thai prompt for math/physics problems
PROMPT = """
You are an expert Mathematics and Physics tutor. Your goal is to help students understand problems by providing clear, step-by-step solutions. You must use LaTeX format for all mathematical equations (e.g., $x^2 + 2x + 1 = 0$). Always respond in the Thai language.

Please analyze the attached image containing a math or physics problem.

Task:
1. Transcript: Extract the text/numbers from the image exactly as they appear.
2. Identify: Briefly state the topic (e.g., Calculus, Newton's Laws).
3. Solution: Solve the problem step-by-step. Explain the logic behind each step.
4. Final Answer: Clearly state the final result.

Format the output nicely using Markdown.
"""

def test_gemini_api(image_path: str):
    """Test Gemini API with image"""

    print("=" * 80)
    print("🧪 Gemini API Test - Physics Problem")
    print("=" * 80)
    print(f"\n📸 Image: {image_path}")

    try:
        # Read and encode image
        print("📤 Reading and encoding image...")
        with open(image_path, 'rb') as f:
            image_data = f.read()

        base64_image = base64.b64encode(image_data).decode('utf-8')
        print(f"   Image size: {len(image_data)} bytes")
        print(f"   Base64 size: {len(base64_image)} characters")

        # Prepare request
        print("\n📝 Preparing API request...")
        payload = {
            "contents": [{
                "parts": [
                    {"text": PROMPT},
                    {
                        "inline_data": {
                            "mime_type": "image/jpeg",
                            "data": base64_image
                        }
                    }
                ]
            }],
            "generationConfig": {
                "temperature": 0.4,
                "topK": 32,
                "topP": 1,
                "maxOutputTokens": 2048
            }
        }

        # Send request
        print("⏳ Sending request to Gemini API...")
        print("   (This may take 5-10 seconds...)\n")

        response = requests.post(
            f"{API_URL}?key={GEMINI_API_KEY}",
            headers={"Content-Type": "application/json"},
            json=payload,
            timeout=30
        )

        print(f"📥 Response status: {response.status_code}")

        if response.status_code == 200:
            result = response.json()

            # Extract text from response
            try:
                answer_text = result['candidates'][0]['content']['parts'][0]['text']

                print("\n" + "=" * 80)
                print("✅ SUCCESS - AI Response")
                print("=" * 80)
                print(answer_text)
                print("\n" + "=" * 80)

                # Analyze response
                print("\n📊 Response Analysis:")
                print(f"   • Length: {len(answer_text)} characters")
                print(f"   • Lines: {answer_text.count(chr(10)) + 1}")
                print(f"   • Has Markdown headers (#): {answer_text.count('#')}")
                print(f"   • Has LaTeX ($): {answer_text.count('$')}")
                print(f"   • Has code blocks (```): {answer_text.count('```')}")
                print(f"   • Has bullet lists (-): {answer_text.count('\\n-')}")
                print(f"   • Has bold (**): {answer_text.count('**')}")

                # Check for Thai language
                thai_chars = sum(1 for c in answer_text if '\u0E00' <= c <= '\u0E7F')
                print(f"   • Thai characters: {thai_chars}")

                # Save response
                with open('gemini_response.txt', 'w', encoding='utf-8') as f:
                    f.write(answer_text)
                print(f"\n💾 Saved to: gemini_response.txt")

                # Save full JSON
                with open('gemini_response_full.json', 'w', encoding='utf-8') as f:
                    json.dump(result, f, ensure_ascii=False, indent=2)
                print(f"💾 Saved full JSON to: gemini_response_full.json")

                # UI Design recommendations
                print("\n" + "=" * 80)
                print("🎨 UI Design Recommendations:")
                print("=" * 80)

                if answer_text.count('#') > 0:
                    print("✓ Use styled headers for sections")

                if answer_text.count('$') > 0:
                    print("✓ Need LaTeX/Math rendering support")

                if answer_text.count('```') > 0:
                    print("✓ Need code block styling")

                if answer_text.count('\\n-') > 0 or answer_text.count('\\n•') > 0:
                    print("✓ Need bullet list styling")

                if thai_chars > 100:
                    print("✓ Use Thai-friendly fonts")

                print("✓ Use scrollable container")
                print("✓ Add syntax highlighting for code")
                print("✓ Use markdown renderer (flutter_markdown)")

            except (KeyError, IndexError) as e:
                print(f"\n❌ Error parsing response: {e}")
                print(f"Response: {json.dumps(result, indent=2, ensure_ascii=False)}")

        else:
            print(f"\n❌ API Error: {response.status_code}")
            print(f"Response: {response.text}")

    except FileNotFoundError:
        print(f"\n❌ File not found: {image_path}")
        print("Please make sure the image file exists")

    except Exception as e:
        print(f"\n❌ Error: {type(e).__name__}: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    # Test with the physics problem image
    # The image should be saved in the project root

    import os

    # Try to find image in current directory
    possible_names = [
        "physics_problem.png",
        "physics_problem.jpg",
        "test_image.png",
        "test_image.jpg",
        "image.png",
        "image.jpg",
    ]

    image_found = False
    for name in possible_names:
        if os.path.exists(name):
            print(f"✅ Found image: {name}\n")
            test_gemini_api(name)
            image_found = True
            break

    if not image_found:
        print("📝 Please save the physics problem image as one of:")
        for name in possible_names:
            print(f"   - {name}")
        print("\nThen run this script again")
