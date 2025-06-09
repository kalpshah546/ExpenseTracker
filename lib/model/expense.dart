import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final uuid = Uuid();
final dateprint = DateFormat.Md();

enum Category { food, travel, leisure, work }

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.work: Icons.work,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
};

class Expense {
  Expense(this.title, this.amount, this.date, this.category) : id = uuid.v4();

  String id;
  String title;
  double amount;
  DateTime date;
  Category category;
  get formattedDate {
    return dateprint.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket(this.reqCategory, this.expenses);
  ExpenseBucket.toCategory(List<Expense> allExpenses, this.reqCategory)
    : expenses =
          allExpenses
              .where((expense) => expense.category == reqCategory)
              .toList();
  final Category reqCategory;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (int i = 0; i < expenses.length; i++) {
      sum += expenses[i].amount;
    }
    return sum;
  }
}
