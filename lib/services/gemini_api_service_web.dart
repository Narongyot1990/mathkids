import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Gemini API Service for solving math/physics problems from images (Web version)
class GeminiApiServiceWeb {
  static const String _apiKey = 'AIzaSyDTSXm0WpXt2SPPhKZzhxFCHWrI0iJB6YY';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  /// Solve math/physics problem from image bytes (for Web)
  Future<GeminiResponse> solveMathFromImageBytes(
    Uint8List imageBytes, {
    String? customPrompt,
  }) async {
    try {
      // Convert bytes to base64
      final base64Image = base64Encode(imageBytes);

      // Default prompt in Thai
      final prompt = customPrompt ??
          r'''
คุณเป็นติวเตอร์คณิตศาสตร์และฟิสิกส์ผู้เชี่ยวชาญ เป้าหมายคือช่วยนักเรียนเข้าใจโจทย์โดยให้คำตอบแบบทีละขั้นตอน

กฎการจัดรูปแบบ LaTeX (สำคัญมาก):
- สมการทางคณิตศาสตร์ทุกตัวต้องอยู่ใน $ หรือ $$ เท่านั้น
- ใช้ $...$ สำหรับสมการในบรรทัดเดียวกับข้อความ เช่น $x^2 + 2x + 1 = 0$
- ใช้ $$...$$ สำหรับสมการแยกบรรทัด เช่น $$\frac{a}{b} = c$$
- ต้องมี $ เปิดและปิดครบคู่เสมอ ห้ามใช้ $ ไม่ครบ

วิเคราะห์รูปภาพโจทย์คณิตศาสตร์/ฟิสิกส์ต่อไปนี้:

หัวข้อที่ต้องตอบ:
1. Transcript (ถอดข้อความ): เขียนโจทย์ที่เห็นในรูปทุกอย่างเป็นข้อความ (ใช้ LaTeX สำหรับสมการ)
2. ประเภท: บอกว่าโจทย์เป็นเรื่องอะไร (เช่น พีชคณิต, แคลคูลัส, กลศาสตร์)
3. วิธีทำ: แก้โจทย์ทีละขั้นตอน อธิบายเหตุผลของแต่ละขั้น (ใช้ Markdown + LaTeX)
4. คำตอบ: สรุปคำตอบสุดท้ายให้ชัดเจน

ตัวอย่างการใช้ LaTeX ที่ถูกต้อง:
- ในบรรทัด: กำหนดให้ $f(x) = x^2 + 1$ แล้ว...
- แยกบรรทัด:
$$\frac{x^2 + y^2}{z} = 1$$

- สำหรับ \begin{cases}: ต้องครอบด้วย $$ ด้วย
$$f(x) = \begin{cases} x+1 & x \le 0 \\ x^2 & x > 0 \end{cases}$$

ห้าม:
- ❌ \frac{1}{2} (ไม่มี $)
- ❌ $\frac{1}{2 (ไม่มี $ ปิด)
- ❌ \begin{cases} x \end{cases} (ไม่มี $$)

ตอบเป็นภาษาไทยทั้งหมด ยกเว้น LaTeX code
''';

      // Prepare request body
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 2048,
        }
      };

      // Send request
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text != null && text.isNotEmpty) {
          return GeminiResponse(
            success: true,
            answer: text,
          );
        } else {
          return GeminiResponse(
            success: false,
            error: 'AI ไม่ตอบกลับ',
          );
        }
      } else {
        return GeminiResponse(
          success: false,
          error: 'HTTP Error: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      return GeminiResponse(
        success: false,
        error: 'เกิดข้อผิดพลาด: ${e.toString()}',
      );
    }
  }
}

/// Response model from Gemini API
class GeminiResponse {
  final bool success;
  final String? answer;
  final String? error;

  GeminiResponse({
    required this.success,
    this.answer,
    this.error,
  });
}
