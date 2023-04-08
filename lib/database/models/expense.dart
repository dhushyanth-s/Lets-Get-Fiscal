import 'package:drift/drift.dart';
import 'package:expense_tracker/database/models/importance.dart';
import 'package:uuid/uuid.dart';

import 'label.dart';

class Expenses extends Table {
  TextColumn get id => text().clientDefault(
        () => const Uuid().v4(),
      )();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  TextColumn get title => text()();
  TextColumn get notes => text()();
  DateTimeColumn get date => dateTime().withDefault(currentDate)();
  TextColumn get importance => textEnum<Importance>()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName("ExpenseLabelEntry")
class ExpenseLabels extends Table {
  TextColumn get expenseId => text().references(Expenses, #id)();
  TextColumn get labelId => text().references(Labels, #id)();
}
