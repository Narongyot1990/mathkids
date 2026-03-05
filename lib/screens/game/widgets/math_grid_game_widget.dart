import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Math Grid (Crossword) Game Widget
/// Displays a 5x5 crossword grid with drag-and-drop answer slots
class MathGridWidget extends StatefulWidget {
  final List<String> gridLayout;
  final List<int> dragOptions;
  final List<int> correctAnswers;
  final Function(bool) onComplete;

  const MathGridWidget({
    super.key,
    required this.gridLayout,
    required this.dragOptions,
    required this.correctAnswers,
    required this.onComplete,
  });

  @override
  State<MathGridWidget> createState() => _MathGridWidgetState();
}

class _MathGridWidgetState extends State<MathGridWidget> {
  // Map slot index to value (null = empty)
  late Map<int, int?> slotValues;

  // All available numbers to drag (always show all 4 options)
  late List<int> allOptions;

  @override
  void initState() {
    super.initState();
    slotValues = {};
    allOptions = List.from(widget.dragOptions);

    // Find all '?' slots and initialize to null
    for (int i = 0; i < widget.gridLayout.length; i++) {
      if (widget.gridLayout[i] == '?') {
        slotValues[i] = null;
      }
    }
  }

  void _onDrop(int slotIndex, int value) {
    setState(() {
      // Just set the value - simple!
      slotValues[slotIndex] = value;

      // Check if all slots filled
      _checkIfComplete();
    });
  }

  void _onRemove(int slotIndex) {
    setState(() {
      // Just clear the slot
      slotValues[slotIndex] = null;
    });
  }

  void _checkIfComplete() {
    // Check if all slots are filled
    if (!slotValues.values.contains(null)) {
      // Check if all answers are correct
      bool allCorrect = true;

      int answerIndex = 0;
      for (final entry in slotValues.entries) {
        if (entry.value != widget.correctAnswers[answerIndex]) {
          allCorrect = false;
          break;
        }
        answerIndex++;
      }

      // If all correct, pass to next question
      if (allCorrect) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onComplete(true);
          }
        });
      }
      // If wrong, do nothing - let user fix it
    }
  }

  // Check if a number is already used in any slot
  bool _isNumberUsed(int number) {
    return slotValues.values.contains(number);
  }

  List<List<String>> _splitIntoRows() {
    // Split gridLayout into rows of 5 items each
    final rows = <List<String>>[];
    for (int i = 0; i < widget.gridLayout.length; i += 5) {
      final end = (i + 5 < widget.gridLayout.length) ? i + 5 : widget.gridLayout.length;
      rows.add(widget.gridLayout.sublist(i, end));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _splitIntoRows();
    int globalIndex = 0;

    // คำนวณขนาดช่องให้พอดีหน้าจอ (responsive)
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = ((screenWidth - 80) / 5).clamp(45.0, 60.0); // ลดจาก 60 เป็น 45-60
    final cellPadding = (cellSize * 0.06).clamp(2.0, 5.0); // padding ตามขนาดช่อง
    final fontSize = (cellSize * 0.5).clamp(22.0, 30.0); // ขนาดตัวอักษรตามขนาดช่อง

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), // ลด padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Grid display - each equation as a row
          ...rows.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8), // ลดจาก 15 เป็น 8
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((item) {
                  final currentIndex = globalIndex++;

                  // Empty cell
                  if (item.isEmpty) {
                    return SizedBox(
                      width: cellSize,
                      height: cellSize,
                    );
                  }

                  // Drag target for '?'
                  if (item == '?') {
                    final currentSlotIndex = currentIndex;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: cellPadding),
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (data) => true,
                        onAcceptWithDetails: (details) {
                          _onDrop(currentSlotIndex, details.data);
                        },
                        builder: (context, candidateData, rejectedData) {
                          final hasValue = slotValues[currentSlotIndex] != null;

                          return GestureDetector(
                            onTap: hasValue ? () => _onRemove(currentSlotIndex) : null,
                            child: Container(
                              width: cellSize,
                              height: cellSize,
                              decoration: BoxDecoration(
                                color: hasValue
                                    ? AppTheme.primaryOrange.withValues(alpha: 0.3)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: candidateData.isNotEmpty
                                      ? AppTheme.primaryOrange
                                      : AppTheme.primaryBlue,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  hasValue ? '${slotValues[currentSlotIndex]}' : '?',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                    color: hasValue ? AppTheme.primaryOrange : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // Regular cell (numbers and operators)
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: cellPadding),
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        color: item == '+' || item == '-' || item == '='
                            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                            : AppTheme.primaryGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: item == '+' || item == '-' || item == '='
                                ? AppTheme.primaryBlue
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
            }).toList(),
          ),
        );
      }),
          const SizedBox(height: 20), // ลดจาก 40 เป็น 20
          // Draggable options - always show all 4 options (responsive size)
          Wrap(
            spacing: 10, // ลดจาก 15 เป็น 10
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: allOptions.map((option) {
              final isUsed = _isNumberUsed(option);
              final dragSize = cellSize * 1.2; // ขนาด draggable ตามขนาดช่อง
              final dragFontSize = fontSize * 1.2; // ขนาดตัวอักษรตาม

              return Draggable<int>(
                key: ValueKey('drag_$option'),
                data: option,
                feedback: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: dragSize,
                    height: dragSize,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        '$option',
                        style: TextStyle(
                          fontSize: dragFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  width: dragSize,
                  height: dragSize,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Opacity(
                  opacity: isUsed ? 0.5 : 1.0,
                  child: Container(
                    width: dragSize,
                    height: dragSize,
                    decoration: BoxDecoration(
                      color: isUsed
                          ? Colors.grey
                          : AppTheme.primaryOrange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        '$option',
                        style: TextStyle(
                          fontSize: dragFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
