import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import '../../../helper/app_string.dart';
import '../../../helper/color_helper.dart';
import '../../../helper/sizer.dart';
import '../common_widget.dart';

class MiniCalander extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const MiniCalander({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 6,
  });

  @override
  State<MiniCalander> createState() => _CustomMiniCalendarState();
}

class _CustomMiniCalendarState extends State<MiniCalander> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.initialDate ?? DateTime.now();
    _selectedDate = widget.initialDate;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysBefore = firstDay.weekday % 7;
    final daysAfter = 6 - (lastDay.weekday % 7);

    final totalDays = daysBefore + lastDay.day + daysAfter;
    final startDate = firstDay.subtract(Duration(days: daysBefore));

    return List.generate(
      totalDays,
      (index) => startDate.add(Duration(days: index)),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorHelper();
    final days = _getDaysInMonth(_focusedMonth);
    final monthName = DateFormat('MMMM yyyy').format(_focusedMonth);

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          height(10),
          // --- Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0), // optional
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.chevron_left,
                    color: widget.textColor,
                    size: 26,
                  ),
                  onPressed: _goToPreviousMonth,
                ),
                appText(
                  monthName,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: widget.textColor,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.chevron_right,
                    color: widget.textColor,
                    size: 26,
                  ),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
          ),

          height(8),

          // --- Weekdays Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map(
                    (e) => Expanded(
                      child: Center(
                        child: appText(
                          e,
                          color: widget.textColor.withOpacity(0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          height(3),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: divider(color: colors.borderColor.withValues(alpha: 0.3)),
          ),

          // --- Days Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
            child: GridView.builder(
              padding: const EdgeInsets.only(bottom: 12, top: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1.3),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = _selectedDate != null &&
                    day.year == _selectedDate!.year &&
                    day.month == _selectedDate!.month &&
                    day.day == _selectedDate!.day;
                final isToday = DateUtils.isSameDay(day, DateTime.now());
                final isCurrentMonth = day.month == _focusedMonth.month;

                Color bgColor = Colors.transparent;
                Color textColor = widget.textColor;

                if (isSelected) {
                  bgColor = widget.primaryColor;
                  textColor = Colors.white;
                } else if (isToday) {
                  bgColor = widget.primaryColor.withOpacity(0.1);
                }

                return GestureDetector(
                  onTap: () {
                    if (isCurrentMonth) {
                      setState(() {
                        _selectedDate = day;
                      });
                    }
                  },
                  child: Center(
                    child: Container(
                      // 👇 smaller selection circle/box
                      width: 37, // adjust to make selection smaller
                      height: 38,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(4), // shape control
                      ),
                      child: Center(
                        child: appText(
                          '${day.day}',
                          color: isCurrentMonth
                              ? textColor
                              : widget.textColor.withOpacity(0.4),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- OK Button
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
            child: SizedBox(
              width: double.infinity,
              child: buttonContainer(
                color: AppColorHelper().primaryColor,
                onPressed: _selectedDate == null
                    ? null
                    : () {
                        widget.onDateSelected(_selectedDate!);
                      },
                appText(
                  "Apply Dates",
                  fontWeight: FontWeight.w500,
                  color: AppColorHelper().textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
