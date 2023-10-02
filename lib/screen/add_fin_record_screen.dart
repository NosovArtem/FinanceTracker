import 'package:finance_tracker/model/financial_record.dart';
import 'package:flutter/material.dart';

import '../model/expense_category.dart';

class AddTransactionScreen extends StatefulWidget {
  final FinancialRecord? initialData;
  final List<ExpenseCategory> categoryList;
  final String? selected;

  AddTransactionScreen(
      {Key? key, this.initialData, required this.categoryList, this.selected})
      : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Map<String, ExpenseCategory> mapNameToCategory = {};
  Map<int, ExpenseCategory> mapIdToCategory = {};
  List<String> keys = [];
  late String selectedValue;

  get _categories => widget.categoryList;

  @override
  void initState() {
    super.initState();
    for (var value in _categories) {
      mapNameToCategory[value.name] = value;
      mapIdToCategory[value.id] = value;
      keys.add(value.name);
    }
    if (widget.initialData != null) {
      selectedValue = mapIdToCategory[widget.initialData!.id]!.name;
      amountController.text = widget.initialData!.amount.toString();
      noteController.text = widget.initialData!.note;
    } else {
      selectedValue = widget.selected!;
    }
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
              value: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: keys.map((key) {
                return DropdownMenuItem(value: key, child: Text(key));
              }).toList(),
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Сумма'),
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Заметка'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newRecord = FinancialRecord(
                    id: widget.initialData?.id ?? -1,
                    userId: widget.initialData?.userId ?? 1,
                    categoryId: mapNameToCategory[selectedValue]!.id,
                    amount: double.parse(amountController.text),
                    note: noteController.text,
                    date: DateTime.now());
                Navigator.pop(
                    context, {"old": widget.initialData, "new": newRecord});
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
