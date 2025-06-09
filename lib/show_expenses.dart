import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ShowExpenses extends StatelessWidget {
  const ShowExpenses(this.onDelete, this.expenses, {super.key});
  final List<Expense> expenses;
  final void Function(Expense) onDelete;
  @override
  Widget build(BuildContext context) {
    //can use column but the lenght of list is not certain and to create a scrollabe list ListView is used
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(expenses[index]),
          background: Container(
            color: kcolorScheme.error.withAlpha(75),
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          onDismissed: (direction) {
            onDelete(expenses[index]);
          },
          child: ExpenseItem(expenses[index]),
        );
      },
    );
  }
}

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenseitem, {super.key});
  final Expense expenseitem;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expenseitem.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '\u20B9${expenseitem.amount.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(categoryIcon[expenseitem.category]),
                    SizedBox(width: 8),
                    Text(
                      expenseitem.formattedDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
