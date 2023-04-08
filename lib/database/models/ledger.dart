import 'package:drift/drift.dart';
import 'models.dart';
import 'package:uuid/uuid.dart';

// class Ledger {
//   Budget? budget;
//   List<LedgerEntry> entries;

//   Ledger({
//     required this.entries,
//     this.budget,
//   });
// }

// enum LedgerEntryType { expense, transaction }

// class LedgerEntry {
//   LedgerEntryType type;
//   String title;
//   double amount;
//   DateTime date;
//   Importance? importance;
//   List<String> labels;
//   Person? person;

//   LedgerEntry({
//     required this.type,
//     required this.title,
//     required this.amount,
//     required this.date,
//     this.importance,
//     required this.labels,
//     this.person,
//   }) {
//     assert(type == LedgerEntryType.expense
//         ? importance != null && person == null
//         : importance == null && person != null);
//   }
// }

// class Budget {
//   double overallBudget;
//   Map<String, double> categoryBudgets;

//   Budget({
//     required this.overallBudget,
//     required this.categoryBudgets,
//   });
// }

class Ledger extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get expenseId => text().references(Expenses, #id).nullable()();
  TextColumn get transactionId => text().references(Transactions, #id).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
