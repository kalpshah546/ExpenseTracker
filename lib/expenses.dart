import 'package:expense_tracker/chart.dart';
import 'package:expense_tracker/expense_input.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/show_expenses.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> registeredExpenses = [
    Expense('Gym', 3600, DateTime.now(), Category.work),
  ];
  void openOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (cxt) {
        return ExpenseInput(addnewItem);
      },
    );
  }

  void addnewItem(Expense item) {
    setState(() {
      registeredExpenses.add(item);
      Navigator.pop(context);
    });
  }

  void removeItem(Expense item) {
    final expenseIndex = registeredExpenses.indexOf(item);
    setState(() {
      registeredExpenses.remove(item);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Expense Deleted'),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                registeredExpenses.insert(expenseIndex, item);
              });
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget mainContent = Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Text(
          'Tap + to add new expenses so that you can remember why your purse is always empty',
          textAlign: TextAlign.center,
        ),
      ),
    );

    final isExpensesEmpty = registeredExpenses.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text('ExpenseTracker'),
        actions: [IconButton(onPressed: openOverlay, icon: Icon(Icons.add))],
      ),
      body:
          width < 600
              ? Column(
                children: [
                  Chart(expenses: registeredExpenses),
                  ShowTotal(registeredExpenses),
                  Expanded(
                    child:
                        isExpensesEmpty
                            ? mainContent
                            : ShowExpenses(removeItem, registeredExpenses),
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Chart(expenses: registeredExpenses),
                        ShowTotal(registeredExpenses),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        isExpensesEmpty
                            ? mainContent
                            : ShowExpenses(removeItem, registeredExpenses),
                  ),
                ],
              ),
    );
  }
}

class ShowTotal extends StatelessWidget {
  const ShowTotal(this.allExpense, {super.key});
  final List<Expense> allExpense;
  double totalToday(List<Expense> expenses) {
    double sum = 0;
    var now = DateTime.now();
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].date.day == now.day &&
          expenses[i].date.month == now.month &&
          expenses[i].date.year == now.year) {
        sum += expenses[i].amount;
      }
    }
    return sum;
  }

  double totalMonth(List<Expense> expenses) {
    double sum = 0;
    var now = DateTime.now();
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].date.month == now.month &&
          expenses[i].date.year == now.year) {
        sum += expenses[i].amount;
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.today, color: Theme.of(context).colorScheme.primary),
                SizedBox(height: 4),
                Text("Today"),
                Text("₹${totalToday(allExpense).toStringAsFixed(2)}"),
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 4),
                Text("This Month"),
                Text("₹${totalMonth(allExpense).toStringAsFixed(2)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
