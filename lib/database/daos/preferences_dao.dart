import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:drift/drift.dart';

import '../database.dart';
import '../models/models.dart';

part 'preferences_dao.g.dart';

@DriftAccessor(tables: [Preferences])
class PreferencesDao extends DatabaseAccessor<MainDatabase>
    with _$PreferencesDaoMixin {
  final MainDatabase db;

  PreferencesDao(this.db) : super(db);

  Future<Currency?> getDefaultCurrency() async {
    try {
      final prefs = await (select(db.preferences)
            ..where((tbl) => tbl.key.equals('default_currency')))
          .getSingle();
      return Currency.from(json: jsonDecode(prefs.value));
    } catch (e) {
      return null;
    }
  }

  Future updateDefaultCurrency(Currency currency) async {
    await into(preferences).insertOnConflictUpdate(
      Preference(
        key: "default_currency",
        value: jsonEncode(
          currency.toJson(),
        ),
      ),
    );
  }
}
