import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

class PersianDatePicker extends StatefulWidget {
  final Jalali initialDate;

  const PersianDatePicker({
    super.key,
    required this.initialDate,
  });

  @override
  State<PersianDatePicker> createState() => _PersianDatePickerState();
}

class _PersianDatePickerState extends State<PersianDatePicker> {
  // تاریخی که کاربر انتخاب کرده (و قرار است برگردانده شود)
  late Jalali selectedDate;
  // تاریخی که الان دارد در تقویم نمایش داده می‌شود (مثلا کاربر رفته به ماه بعد ولی هنوز انتخاب نکرده)
  late Jalali viewDate;

  final List<String> monthNames = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
    'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند',
  ];

  final List<String> weekDays = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    viewDate = widget.initialDate;
  }

  void _changeMonth(int amount) {
    setState(() {
      viewDate = viewDate.addMonths(amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: SizedBox(
          width: 320, // عرض استاندارد پیکر متریال
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- 1. هدر (Header) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedDate.year}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${selectedDate.formatter.wN}، ${selectedDate.day} ${selectedDate.formatter.mN}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // --- 2. بدنه تقویم ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Column(
                  children: [
                    // نوار جابجایی ماه
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => _changeMonth(-1), // ماه قبل
                        ),
                        Text(
                          '${monthNames[viewDate.month - 1]} ${viewDate.year}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => _changeMonth(1), // ماه بعد
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // روزهای هفته
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekDays.map((e) => Text(
                        e,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),).toList(),
                    ),

                    const SizedBox(height: 10),

                    // شبکه روزها (Grid)
                    SizedBox(
                      height: 240, // ارتفاع ثابت برای شبکه
                      child: _buildCalendarGrid(primaryColor),
                    ),
                  ],
                ),
              ),

              // --- 3. دکمه‌ها (Actions) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('لغو'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, selectedDate),
                      child: const Text('تایید'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(Color activeColor) {
    // محاسبه روز اول ماه برای اینکه بفهمیم چند تا خانه خالی باید اولش بگذاریم
    // در shamsi_date: روز ۱ = شنبه، ۷ = جمعه
    final firstDayOfMonth = viewDate.copy(day: 1);
    final int startWeekDay = firstDayOfMonth.weekDay; // 1 تا 7

    // آفست: چون شنبه (1) باید ایندکس 0 باشد.
    final int emptySlots = startWeekDay - 1;
    final int daysInMonth = viewDate.monthLength;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 روز هفته
        childAspectRatio: 1.0,
      ),
      itemCount: daysInMonth + emptySlots,
      itemBuilder: (context, index) {
        if (index < emptySlots) {
          return const SizedBox(); // خانه‌های خالی اول ماه
        }

        final int dayNumber = index - emptySlots + 1;
        final bool isSelected = (selectedDate.year == viewDate.year &&
            selectedDate.month == viewDate.month &&
            selectedDate.day == dayNumber);

        final bool isToday = (Jalali.now().year == viewDate.year &&
            Jalali.now().month == viewDate.month &&
            Jalali.now().day == dayNumber);

        return InkWell(
          onTap: () {
            setState(() {
              selectedDate = viewDate.copy(day: dayNumber);
            });
          },
          customBorder: const CircleBorder(),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: activeColor, width: 1)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// تابع کمکی برای فراخوانی راحت
Future<Jalali?> showMyPersianDatePicker(BuildContext context, Jalali initialDate) async {
  return await showDialog<Jalali>(
    context: context,
    builder: (context) => PersianDatePicker(initialDate: initialDate),
  );
}