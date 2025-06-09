import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/rendering.dart';

class ExpenseInput extends StatefulWidget {
  const ExpenseInput(this.addFunction, {super.key});
  final void Function(Expense) addFunction;
  @override
  State<StatefulWidget> createState() {
    return _ExpenseInput();
  }
}

class _ExpenseInput extends State<ExpenseInput> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  Category storecategory = Category.leisure;
  DateTime? storedate;
  void presentDate() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: first,
      lastDate: now,
    );
    setState(() {
      storedate = pickedDate!;
    });
  }

  void submitExpenseData() {
    final enteredAmount = double.tryParse(amountController.text);
    bool isAmountValid = false;

    if (enteredAmount == null || enteredAmount <= 0) {
      isAmountValid = true;
    }
    if (titleController.text.trim().isEmpty ||
        isAmountValid ||
        storedate == null) {
      //give error
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Invalid Input',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text(
              'Please make sure that the values of title, amount, date, and category are correctly set...',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'),
              ),
            ],
          );
        },
      );
      return;
    }
    Expense temp = Expense(
      titleController.text.trim(),
      enteredAmount!,
      storedate!,
      storecategory,
    );
    widget.addFunction(temp);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + keyboardSpace),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: titleController,
                            maxLength: 50,
                            decoration: InputDecoration(label: Text('Title')),
                          ),
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixText: '\u20B9 ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: titleController,
                      maxLength: 50,
                      decoration: InputDecoration(label: Text('Title')),
                    ),
                  SizedBox(height: 20),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          style: Theme.of(context).textTheme.bodyMedium,
                          value: storecategory,
                          items:
                              Category.values.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                );
                              }).toList(),
                          onChanged: (values) {
                            if (values == null) {
                              return;
                            }
                            setState(() {
                              storecategory = values;
                            });
                          },
                        ),
                        SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                storedate == null
                                    ? 'No date selected yet'
                                    : dateprint.format(storedate!),
                              ),
                              IconButton(
                                onPressed: presentDate,
                                icon: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: amountController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              prefixText: '\u20B9 ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                storedate == null
                                    ? 'No date selected yet'
                                    : dateprint.format(storedate!),
                              ),
                              IconButton(
                                onPressed: presentDate,
                                icon: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 40),
                  if (width >= 600)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            submitExpenseData();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          style: Theme.of(context).textTheme.bodyMedium,
                          value: storecategory,
                          items:
                              Category.values.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                );
                              }).toList(),
                          onChanged: (values) {
                            if (values == null) {
                              return;
                            }
                            setState(() {
                              storecategory = values;
                            });
                          },
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            submitExpenseData();
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
