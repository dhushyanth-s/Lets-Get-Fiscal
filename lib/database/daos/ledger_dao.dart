import 'package:drift/drift.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/database/models/models.dart';

part 'ledger_dao.g.dart';

/// Ledges should be combination of transactions, expenses and any other thing
///  like recurring expense which I might add in the Future.
@DriftAccessor(tables: [Ledger])
class LedgerDao extends DatabaseAccessor<MainDatabase> with _$LedgerDaoMixin {
  LedgerDao(MainDatabase db) : super(db);

  // add expense ledger entry
  Future<void> insertExpenseLedgerEntry(Expense expense) async {
    await into(ledger).insert(LedgerCompanion.insert(expenseId: Value.ofNullable(expense.id)));
  }

  // add transaction ledger entry
  Future<void> insertTransactionLedgerEntry(Transaction transaction) async {
    await into(ledger).insert(LedgerCompanion.insert(transactionId: Value.ofNullable(transaction.id)));
  }
}
