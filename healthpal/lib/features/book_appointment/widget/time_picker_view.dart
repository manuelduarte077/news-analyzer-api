import 'package:flutter/material.dart';
import 'package:healthpal/core/utils/app_colors/app_colors.dart';

class TimePickerView extends StatefulWidget {
  final ValueChanged<TimeOfDay> onTimeSelected;

  const TimePickerView({super.key, required this.onTimeSelected});

  @override
  State<TimePickerView> createState() => _TimePickerViewState();
}

class _TimePickerViewState extends State<TimePickerView> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.5,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          final time = getTime(index);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTime = time;
              });
              widget.onTimeSelected(getTimeOfDay(time));
            },
            child: Container(
              decoration: BoxDecoration(
                color:
                    selectedTime == time ? AppColors.mirageColor : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: selectedTime == time
                      ? AppColors.mirageColor
                      : Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                    color: selectedTime == time ? Colors.white : Colors.black,
                    fontWeight: selectedTime == time
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getTime(int index) {
    switch (index) {
      case 0:
        return '09.00 AM';
      case 1:
        return '09.30 AM';
      case 2:
        return '10.00 AM';
      case 3:
        return '10.30 AM';
      case 4:
        return '11.00 AM';
      case 5:
        return '11.30 AM';
      case 6:
        return '3.00 PM';
      case 7:
        return '3.30 PM';
      case 8:
        return '4.00 PM';
      case 9:
        return '4.30 PM';
      case 10:
        return '5.00 PM';
      case 11:
        return '5.30 PM';
      default:
        return '';
    }
  }

  TimeOfDay getTimeOfDay(String time) {
    final parts = time.split(' ');
    final hourMinute = parts[0].split('.');
    final hour = int.parse(hourMinute[0]) +
        (parts[1] == 'PM' && hourMinute[0] != '12' ? 12 : 0);
    final minute = int.parse(hourMinute[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
