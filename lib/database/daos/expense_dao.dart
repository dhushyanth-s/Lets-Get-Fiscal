import '../database.dart';
import 'package:drift/drift.dart';

import '../models/models.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<MainDatabase> with _$ExpenseDaoMixin {
  // Called by the AppDatabase class
  ExpenseDao(MainDatabase db) : super(db);

  /// Gives back a list of expenses which are not part
  ///  of a transaction to a person.
  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  /// Gives back a stream of auto updating list of expenses which are
  /// not part of a transaction to a person.
  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();

  /// Inserts a new expense into the database. Returns back
  /// the inserted expense.
  Future<Expense> insertAndGetExpense(ExpensesCompanion expense) async {
    final rowId = await into(expenses).insert(expense);

    final addedExpense = await (select(expenses)
          ..where((tbl) => tbl.rowId.equals(rowId)))
        .getSingle();

    return addedExpense;
  }

  /// Tries to update an expense in the database. Returns back
  /// `True` if it did find a matching expense. Else returns `False`
  Future<bool> updateExpense(Expense expense) =>
      update(expenses).replace(expense);

  /// Deletes expenses matching the given expense. Should delete only 1 row ideally
  /// so should return `1`. Somethings wrong if it returns `0` or more than `1`.
  Future<int> deleteExpense(Expense expense) =>
      delete(expenses).delete(expense);
}
