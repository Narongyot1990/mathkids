import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../core/theme/app_colors.dart';

/// Custom Markdown viewer with LaTeX support
class LatexMarkdownViewer extends StatelessWidget {
  final String data;

  const LatexMarkdownViewer({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Parse and render markdown with LaTeX
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    // Split content by LaTeX delimiters
    final parts = _parseLatexAndMarkdown(data);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: parts.map((part) {
          if (part.isLatex) {
            return _buildLatex(part.content);
          } else {
            return _buildMarkdown(part.content);
          }
        }).toList(),
      ),
    );
  }

  /// Build LaTeX equation
  Widget _buildLatex(String latex) {
    try {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F2FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Math.tex(
            latex,
            textStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            mathStyle: MathStyle.display,
          ),
        ),
      );
    } catch (e) {
      // Fallback if LaTeX parsing fails
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '\$$latex\$',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }
  }

  /// Build Markdown text
  Widget _buildMarkdown(String markdown) {
    if (markdown.trim().isEmpty) return const SizedBox.shrink();

    return MarkdownBody(
      data: markdown,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        // Text styles
        p: TextStyle(
          fontSize: 16,
          height: 1.8,
          color: AppColors.textPrimary,
          letterSpacing: 0.3,
        ),
        // Headers
        h1: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryPurple,
          height: 1.4,
        ),
        h2: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryPurple,
          height: 1.4,
        ),
        h3: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
          height: 1.4,
        ),
        h4: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        // Code
        code: TextStyle(
          fontSize: 15,
          backgroundColor: Color(0xFFF5F2FF),
          color: AppColors.primaryPurple,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w500,
        ),
        codeblockPadding: EdgeInsets.all(16),
        codeblockDecoration: BoxDecoration(
          color: Color(0xFFF5F2FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        // Lists
        listBullet: TextStyle(
          fontSize: 16,
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold,
        ),
        listIndent: 24,
        // Strong (bold)
        strong: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryPurple,
        ),
        // Emphasis (italic)
        em: TextStyle(
          fontStyle: FontStyle.italic,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  /// Parse content into LaTeX and Markdown parts
  List<ContentPart> _parseLatexAndMarkdown(String content) {
    final parts = <ContentPart>[];

    // Multi-pattern regex to catch various LaTeX formats:
    // 1. $$...$$ (block math)
    // 2. $...$ (inline math)
    // 3. \[...\] (alternative block)
    // 4. \(...\) (alternative inline)
    // 5. \begin{cases}...\end{cases} and other environments
    final regex = RegExp(
      r'\$\$(.+?)\$\$|'              // $$...$$
      r'\$(.+?)\$|'                   // $...$
      r'\\\[(.+?)\\\]|'               // \[...\]
      r'\\\((.+?)\\\)|'               // \(...\)
      r'(\\begin\{[^}]+\}.*?\\end\{[^}]+\})',  // \begin{...}...\end{...}
      dotAll: true,
    );

    int lastEnd = 0;
    for (final match in regex.allMatches(content)) {
      // Add markdown before LaTeX
      if (match.start > lastEnd) {
        final markdownText = content.substring(lastEnd, match.start);
        if (markdownText.trim().isNotEmpty) {
          parts.add(ContentPart(content: markdownText, isLatex: false));
        }
      }

      // Extract LaTeX from any matching group
      String latex = '';
      for (int i = 1; i <= match.groupCount; i++) {
        final group = match.group(i);
        if (group != null && group.trim().isNotEmpty) {
          latex = group.trim();
          break;
        }
      }

      if (latex.isNotEmpty) {
        parts.add(ContentPart(content: latex, isLatex: true));
      }

      lastEnd = match.end;
    }

    // Add remaining markdown
    if (lastEnd < content.length) {
      final markdownText = content.substring(lastEnd);
      if (markdownText.trim().isNotEmpty) {
        parts.add(ContentPart(content: markdownText, isLatex: false));
      }
    }

    // If no LaTeX parts found, treat whole content as markdown
    if (parts.isEmpty && content.trim().isNotEmpty) {
      parts.add(ContentPart(content: content, isLatex: false));
    }

    return parts;
  }
}

/// Content part model
class ContentPart {
  final String content;
  final bool isLatex;

  ContentPart({
    required this.content,
    required this.isLatex,
  });
}
