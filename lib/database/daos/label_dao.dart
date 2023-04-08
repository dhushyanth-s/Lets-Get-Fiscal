import 'package:drift/drift.dart';

import '../database.dart';
import '../models/models.dart';

part 'label_dao.g.dart';

@DriftAccessor(tables: [Labels])
class LabelDao extends DatabaseAccessor<MainDatabase> with _$LabelDaoMixin {
  LabelDao(MainDatabase db) : super(db);

  Future<List<Label>> getAllLabels() => select(labels).get();

  Stream<List<Label>> watchAllLabels() => select(labels).watch();

  Future insertLabel(Insertable<Label> label) => into(labels).insert(label);

  Future updateLabel(Insertable<Label> label) => update(labels).replace(label);

  Future deleteLabel(Insertable<Label> label) => delete(labels).delete(label);
}
