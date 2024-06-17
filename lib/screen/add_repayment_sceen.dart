import 'package:finance_tracker/model/repayment.dart';
import 'package:flutter/material.dart';

import '../helper/helper.dart';
import '../widget/date.dart';

class AddRepaymentScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;

  AddRepaymentScreen(this.initialData);

  @override
  _AddRepaymentScreenState createState() => _AddRepaymentScreenState();
}

class _AddRepaymentScreenState extends State<AddRepaymentScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  late DateTimePickerWidget dateTimePickerWidget;

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  @override
  void initState() {
    DateTime dateTime = widget.initialData['date'] ?? DateTime.now();
    dateTimePickerWidget = DateTimePickerWidget(
      initialDate: dateTime,
      controllerDate: dateController,
      controllerTime: timeController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить погашение'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  labelText: 'Сумма'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.format_line_spacing_sharp),
                  labelText: 'Note'),
            ),
            dateTimePickerWidget,
            Center(
              heightFactor: 2,
              child: ElevatedButton(
                onPressed: () async {
                  DateTime d = DateTime.parse(dateController.text);
                  TimeOfDay t = parseTimeOfDay(timeController.text);
                  Repayment newRepayment = Repayment(
                    id: -1,
                    debtLoanId: widget.initialData['debtLoanId'],
                    repaymentDate:
                        DateTime(d.year, d.month, d.day, t.hour, t.minute),
                    repaymentAmount: double.parse(amountController.text),
                    note: noteController.text,
                  );
                  Navigator.pop(context, {"old": null, "new": newRepayment});
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                child: Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
