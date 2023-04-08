import 'package:drift/drift.dart';
import 'package:expense_tracker/database/database.dart';

import '../models/models.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<MainDatabase>
    with _$TransactionDaoMixin {
  final MainDatabase db;

  TransactionDao(this.db) : super(db);

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<Transaction> insertAndGetTransaction(
      TransactionsCompanion transaction) async {
    final rowId = await into(transactions).insert(transaction);

    final addedTransaction = await (select(transactions)
          ..where((tbl) => tbl.rowId.equals(rowId)))
        .getSingle();

    return addedTransaction;
  }
}
