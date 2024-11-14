import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:healthpal/utils/app_colors/app_colors.dart';
import 'package:healthpal/utils/app_images/app_images.dart';
import 'package:healthpal/views/book_appointment/widget/time_picker_view.dart';
import 'package:healthpal/widgets/app_button/app_button.dart';

class MyBookAppointmentWidgetView extends StatefulWidget {
  const MyBookAppointmentWidgetView({super.key});

  @override
  State<MyBookAppointmentWidgetView> createState() =>
      _MyBookAppointmentWidgetViewState();
}

class _MyBookAppointmentWidgetViewState
    extends State<MyBookAppointmentWidgetView> {
  DateTime? selectedDate;
  List<DateTime?> selectedDates = [];
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Reservar cita',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.oxfordBlueColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Seleccionar fecha',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
          ),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: selectedDates,
            onValueChanged: (date) {
              setState(() {
                selectedDates = date.cast<DateTime?>();
                selectedDate = selectedDates.first;
              });
            },
          ),
          const SizedBox(height: 1),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Seleccionar hora',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mirageColor,
              ),
            ),
          ),
          Expanded(
            child: TimePickerView(
              onTimeSelected: (time) {
                selectedTime = time;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppButtonView(
              text: 'Confirmar',
              onTap: () {
                if (selectedDate != null && selectedTime != null) {
                  _dialogBuilder(context, selectedDate!, selectedTime!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder(
    BuildContext context, DateTime selectedDate, TimeOfDay selectedTime) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              child: Image.asset(
                LocalImages.icCongratulationsLogo,
              ),
            ),
            const Text(
              '¡Felicidades!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Su cita con el Dra. Juana Pérez  está confirmada para',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${selectedDate.toLocal().toString().split(' ')[0]} at ${selectedTime.format(context)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            AppButtonView(
              text: 'Done',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Editar su cita',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    },
  );
}
