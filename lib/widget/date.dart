import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/helper.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final TextEditingController controllerDate;
  final TextEditingController controllerTime;

  DateTimePickerWidget({
    required this.initialDate,
    required this.controllerDate,
    required this.controllerTime,
  });

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    widget.controllerDate.text =
        formatDateTime(widget.initialDate, dateFormat)!;

    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(widget.initialDate);
    selectedTime = timeOfDay;
    widget.controllerTime.text = formatTimeOfDay24Hours(timeOfDay);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        widget.controllerDate.text = formatDateTime(picked, dateFormat)!;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        widget.controllerTime.text = formatTimeOfDay24Hours(picked);
      });
    }
  }

  String? formatDateTime(DateTime? dateTime, DateFormat formatter) {
    if (dateTime == null) {
      return null;
    }
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 15.0,
      ),
      Row(
        children: [
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: 150,
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  // Отступы внутри кнопки
                  child: Text(
                    'Date: ${"${selectedDate.toLocal()}".split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.white, // Цвет текста
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 150,
            child: InkWell(
              onTap: () => _selectTime(context),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  // Отступы внутри кнопки
                  child: Text(
                    'Time: ${selectedTime.format(context)}',
                    style: TextStyle(
                      color: Colors.white, // Цвет текста
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 5.0,
      ),
    ]);
  }
}
