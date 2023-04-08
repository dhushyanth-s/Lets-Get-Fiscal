import 'package:drift/drift.dart';

const unAssigned = "Unassigned";

class BudgetDetails extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().withDefault(const Constant(unAssigned))();
  RealColumn get amount => real()();
}
