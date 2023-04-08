import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Labels extends Table {
  TextColumn get id => text().clientDefault(
        () => const Uuid().v4(),
      )();
  TextColumn get name => text()();
  TextColumn get color => text()();
  TextColumn get notes => text()();

  @override
  Set<Column> get primaryKey => {id};
}
