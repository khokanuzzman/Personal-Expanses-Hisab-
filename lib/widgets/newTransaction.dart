import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    void submitData() {
      final enteredTitle = titleController.text;
      final enteredAmount = amountController.text.isNotEmpty
          ? double.parse(amountController.text)
          : 0.0;

      if (amountController.text.isEmpty) {
        return;
      }

      if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
        return;
      }
      widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    }

    void _presetDatePicker() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime.now())
          .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      });
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? "no date chosen"
                      : 'Picked date: ${DateFormat.yMd().format(_selectedDate)}'),
                ),
                TextButton(
                  onPressed: _presetDatePicker,
                  child: Text('choose date'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('Add Transaction'),
              onPressed: () => {submitData()},
            ),
          ],
        ),
      ),
    );
  }
}
