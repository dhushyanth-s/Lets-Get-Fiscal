import 'package:drift/drift.dart';
import 'package:expense_tracker/database/models/person.dart';
import 'package:uuid/uuid.dart';

class Transactions extends Table {
  TextColumn get id => text().clientDefault(
        () => const Uuid().v4(),
      )();
  TextColumn get personId => text().references(People, #id)();
  TextColumn get title => text()();
  RealColumn get amount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get date => dateTime().withDefault(currentDate)();
  TextColumn get notes => text()();

  @override
  Set<Column> get primaryKey => {id};
}
