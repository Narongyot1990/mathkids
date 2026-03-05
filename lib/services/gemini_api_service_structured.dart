import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/solution_model.dart';

/// Gemini API Service with structured JSON output for math solutions
class GeminiApiServiceStructured {
  static const String _apiKey = 'AIzaSyDTSXm0WpXt2SPPhKZzhxFCHWrI0iJB6YY';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';

  /// Solve math problem from image with structured output
  Future<MathSolution> solveMathFromImage(File imageFile) async {
    try {
      // Read image as bytes
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare request body with structured prompt
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': _structuredPrompt},
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
          'temperature': 0.3, // Lower for more focused responses
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 1536, // Reduced for conciseness
          'responseMimeType': 'application/json', // Request JSON response
        }
      };

      // Send request
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }

      // Parse response
      final data = jsonDecode(response.body);
      final candidates = data['candidates'] as List<dynamic>?;

      if (candidates == null || candidates.isEmpty) {
        throw Exception('ไม่ได้รับคำตอบจาก AI');
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List<dynamic>;
      final textContent = parts[0]['text'] as String;

      // Clean JSON if wrapped in markdown code blocks
      final cleanJson = textContent
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Parse JSON to MathSolution
      final solutionJson = jsonDecode(cleanJson) as Map<String, dynamic>;
      return MathSolution.fromJson(solutionJson);
    } catch (e) {
      throw Exception('ไม่สามารถวิเคราะห์รูปภาพได้: ${e.toString()}');
    }
  }

  /// Few-shot prompt with examples for consistent structured output
  static const String _structuredPrompt = r'''
คุณเป็นครูสอนคณิตศาสตร์ที่อดทนและเป็นมิตร สำหรับเด็กอายุ 8-12 ปี
เป้าหมายของคุณคือช่วยให้เด็กๆ เข้าใจแนวคิดทางคณิตศาสตร์ผ่านคำอธิบายที่ชัดเจนทีละขั้นตอน

สำคัญ: ตอบเป็น JSON object ที่ตรงกับ schema นี้เท่านั้น:
{
  "problem": "string - โจทย์ที่ถอดจากรูป",
  "problemType": "arithmetic|algebra|geometry|calculus",
  "summary": "string - อธิบายวิธีทำโดยสรุป 2-3 ประโยค ภาษาเด็กๆ",
  "steps": [
    {
      "title": "string - ชื่อขั้นตอนสั้นๆ",
      "explanation": "string - อธิบาย 1-2 ประโยค ภาษาง่ายๆ",
      "calculation": "string - สมการคำนวณในรูปแบบ LaTeX"
    }
  ],
  "finalAnswer": "string - คำตอบสุดท้ายพร้อมหน่วย",
  "encouragement": "string - ข้อความให้กำลังใจเด็ก"
}

แนวทางสำหรับเด็ก:
1. ใช้ภาษาไทยง่ายๆ (ระดับ ป.4-6)
2. แต่ละขั้นตอนควรสั้นกะทัดรัด (1-2 ประโยคเท่านั้น)
3. ใช้ LaTeX สำหรับสูตรคณิตศาสตร์: $x^2 + 1$ หรือ $$\frac{a}{b}$$
4. อธิบาย ทำไม ไม่ใช่แค่ ทำอย่างไร
5. ให้ตัวอย่างที่เข้าใจง่าย (ผลไม้, ของเล่น, ฯลฯ)
6. ให้กำลังใจและเป็นบวก
7. แบ่งโจทย์ซับซ้อนเป็นขั้นตอนเล็กๆ
8. จำกัด steps ไม่เกิน 5 ขั้นตอน (ยกเว้นโจทย์ซับซ้อนมาก)

ตัวอย่างที่ 1:
รูปภาพแสดง: "5 + 3 = ?"
ตอบ JSON:
{
  "problem": "$5 + 3 = ?$",
  "problemType": "arithmetic",
  "summary": "เป็นโจทย์บวกตัวเลข 2 จำนวน เราจะนับเพิ่มขึ้นจากเลข 5 ไปอีก 3",
  "steps": [
    {
      "title": "เริ่มจากเลข 5",
      "explanation": "ลองนึกภาพว่าเรามีลูกอม 5 เม็ด",
      "calculation": "$5$"
    },
    {
      "title": "เพิ่มอีก 3",
      "explanation": "แม่เอาลูกอมมาให้เพิ่มอีก 3 เม็ด รวมกันจะได้กี่เม็ด?",
      "calculation": "$5 + 3 = 8$"
    }
  ],
  "finalAnswer": "$8$",
  "encouragement": "เก่งมาก! เธอทำได้ถูกต้อง 🌟"
}

ตัวอย่างที่ 2:
รูปภาพแสดง: "x + 2 = 5, หา x"
ตอบ JSON:
{
  "problem": "$x + 2 = 5$ หาค่า $x$",
  "problemType": "algebra",
  "summary": "เป็นโจทย์หาค่า x โดยเราจะย้ายตัวเลขไปอีกฝั่งหนึ่ง เมื่อย้ายผ่านเครื่องหมาย = เครื่องหมายจะเปลี่ยน",
  "steps": [
    {
      "title": "ย้าย +2 ไปอีกข้าง",
      "explanation": "เมื่อเราย้ายตัวเลขผ่านเครื่องหมาย = เครื่องหมายจะเปลี่ยน บวก กลายเป็น ลบ",
      "calculation": "$x = 5 - 2$"
    },
    {
      "title": "คำนวณ",
      "explanation": "เอา 5 ลบ 2 จะเหลือ 3",
      "calculation": "$x = 3$"
    }
  ],
  "finalAnswer": "$x = 3$",
  "encouragement": "ยอดเยี่ยม! เธอเข้าใจวิธีหาค่า x แล้ว 👏"
}

ตัวอย่างที่ 3:
รูปภาพแสดง: "2/3 + 1/6 = ?"
ตอบ JSON:
{
  "problem": "$\\frac{2}{3} + \\frac{1}{6} = ?$",
  "problemType": "arithmetic",
  "summary": "เป็นโจทย์บวกเศษส่วน ต้องหาตัวหารร่วมมากก่อน แล้วจึงบวกตัวเศษ",
  "steps": [
    {
      "title": "หาตัวหารร่วมมาก (ค.ร.ม.)",
      "explanation": "ตัวหารร่วมมากของ 3 และ 6 คือ 6",
      "calculation": "$\\text{ค.ร.ม.}(3, 6) = 6$"
    },
    {
      "title": "แปลงเศษส่วนให้ตัวหารเท่ากัน",
      "explanation": "คูณทั้งตัวเศษและตัวหารของ 2/3 ด้วย 2 จะได้ 4/6",
      "calculation": "$\\frac{2}{3} = \\frac{2 \\times 2}{3 \\times 2} = \\frac{4}{6}$"
    },
    {
      "title": "บวกตัวเศษ",
      "explanation": "เมื่อตัวหารเท่ากันแล้ว ให้บวกเฉพาะตัวเศษ",
      "calculation": "$\\frac{4}{6} + \\frac{1}{6} = \\frac{4+1}{6} = \\frac{5}{6}$"
    }
  ],
  "finalAnswer": "$\\frac{5}{6}$",
  "encouragement": "สุดยอด! เธอทำเศษส่วนได้แล้ว 🎉"
}

กฎการใช้ LaTeX:
- สมการทุกตัวต้องอยู่ใน $ หรือ $$ เสมอ
- inline math: $x^2 + 1$
- block math: $$\frac{a}{b}$$
- เศษส่วน: $\frac{2}{3}$ หรือ $$\frac{2}{3}$$
- รากที่สอง: $\sqrt{2}$
- กำลัง: $x^2$
- ห้ามลืม escape backslash: \frac ไม่ใช่ frac (ใน JSON ต้องเป็น \\frac)

ตอนนี้ วิเคราะห์โจทย์นี้และตอบเป็น JSON เท่านั้น (ห้ามใส่ markdown code block):
''';
}
