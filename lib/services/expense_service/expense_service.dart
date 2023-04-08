import 'package:drift/drift.dart';
import 'package:expense_tracker/database/daos/expense_dao.dart';
import 'package:expense_tracker/services/expense_service/models.dart';
import 'package:get/get.dart' as g;

import '../../database/daos/ledger_dao.dart';
import '../../database/daos/transaction_dao.dart';
import '../../database/database.dart';

class ExpenseService {
  /// Can add both Expense or Transaction
  static Future<void> add(InsertExpenseOrTransaction entry) async {
    final LedgerDao ledgerDao = g.Get.find();

    // Check if expense or transaction
    if (entry.importance != null) {
      // add expense

      final ExpenseDao expenseDao = g.Get.find();

      final addedExpense = await expenseDao.insertAndGetExpense(
        ExpensesCompanion.insert(
          title: entry.title,
          amount: Value(entry.amount),
          notes: entry.notes,
          importance: entry.importance!,
          date: Value.ofNullable(entry.date),
          id: Value.ofNullable(entry.id),
        ),
      );

      // Add ledger entry
      await ledgerDao.insertExpenseLedgerEntry(addedExpense);
    } else {
      // Add transaction

      final TransactionDao transactionDao = g.Get.find();

      final addedTransaction = await transactionDao
          .insertAndGetTransaction(TransactionsCompanion.insert(
        personId: entry.person!,
        title: entry.title,
        notes: entry.notes,
        amount: Value.ofNullable(entry.amount),
        date: Value.ofNullable(entry.date),
      ));

      await ledgerDao.insertTransactionLedgerEntry(addedTransaction);
    }
  }
}
