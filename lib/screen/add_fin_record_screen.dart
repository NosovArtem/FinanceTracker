import 'package:finance_tracker/model/financial_record.dart';
import 'package:flutter/material.dart';

import '../helper/helper.dart';
import '../model/expense_category.dart';
import '../widget/date.dart';

class AddTransactionScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final List<ExpenseCategory> categoryList;

  AddTransactionScreen(this.initialData, this.categoryList);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Map<String, ExpenseCategory> mapNameToCategory = {};
  List<String> keys = [];
  late String selectedValue;

  get _categories => widget.categoryList;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  late DateTimePickerWidget dateTimePickerWidget;

  @override
  void initState() {
    super.initState();
    for (var value in _categories) {
      mapNameToCategory[value.name] = value;
      keys.add(value.name);
    }

    selectedValue = widget.initialData['cat_name'] ?? "";
    amountController.text = widget.initialData['amount'] != null
        ? widget.initialData['amount'].toString()
        : "";
    noteController.text = widget.initialData['note'] ?? "";

    DateTime dateTime = widget.initialData['date'] ?? DateTime.now();
    dateTimePickerWidget = DateTimePickerWidget(
      initialDate: dateTime,
      controllerDate: dateController,
      controllerTime: timeController,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить запись'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.label_important),
              ),
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: keys.map((key) {
                return DropdownMenuItem(
                    value: key,
                    child: Center(child: Text(key),));
              }).toList(),
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money), labelText: 'Сумма'),
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.format_line_spacing_sharp), labelText: 'Заметка'),
            ),
            dateTimePickerWidget,
            Center(
              heightFactor: 2,
              child: ElevatedButton(
                onPressed: () async {
                  DateTime d = DateTime.parse(dateController.text);
                  TimeOfDay t = parseTimeOfDay(timeController.text);
                  final newRecord = FinancialRecord(
                    id: widget.initialData['id'] ?? -1,
                    userId: widget.initialData['userId'] ?? 1,
                    category: mapNameToCategory[selectedValue]!,
                    amount: double.parse(amountController.text),
                    note: noteController.text,
                    date: DateTime(d.year, d.month, d.day, t.hour, t.minute),
                  );
                  Navigator.pop(
                      context, {"old": widget.initialData, "new": newRecord});
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
