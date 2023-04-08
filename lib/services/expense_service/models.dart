import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/database/models/models.dart';

class InsertExpenseOrTransaction {
  String title;
  double amount;
  String notes;
  String? person;
  DateTime? date;
  String? id;
  List<Label>? labels;
  Importance? importance;

  InsertExpenseOrTransaction({
    required this.title,
    required this.amount,
    required this.notes,
    this.person,
    this.date,
    this.id,
    this.labels,
    this.importance
  }) {
    assert(importance == null || person == null);
    assert(!(importance == null && person == null));
  }
}
