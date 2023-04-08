import '../database.dart';
import 'package:drift/drift.dart';
import '../models/models.dart';

part 'person_dao.g.dart';

@DriftAccessor(tables: [People])
class PersonDao extends DatabaseAccessor<MainDatabase> with _$PersonDaoMixin {
  final MainDatabase db;

  PersonDao(this.db) : super(db);

  Future<List<Person>> getAllPersons() => select(people).get();

  Stream<List<Person>> watchAllPersons() => select(people).watch();

  Future insertPerson(PeopleCompanion person) => into(people).insert(person);

  Future updatePerson(Person person) => update(people).replace(person);

  Future deletePerson(Person person) => delete(people).delete(person);
}