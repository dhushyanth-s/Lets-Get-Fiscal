import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

@DataClassName("Person")
class People extends Table {
  TextColumn get id => text().clientDefault(
        () => const Uuid().v4(),
      )();
  TextColumn get name => text()();
  BlobColumn get image => blob().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
