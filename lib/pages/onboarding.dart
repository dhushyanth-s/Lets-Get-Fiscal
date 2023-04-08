import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker/database/daos/preferences_dao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Currency? currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 16,
              right: 16,
            ),
            child: Text(
              "Default Currency",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(top: 40),
                  child: ListTile(
                    title: Text(currency?.name ?? "Select Currency"),
                    trailing: currency != null
                        ? CircleAvatar(child: Text(currency!.symbol))
                        : Icon(Icons.add),
                    onTap: () {
                      showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currency) {
                          setState(() {
                            this.currency = currency;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.check),
                label: const Text('Done'),
                onPressed: () async {
                  if (currency == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a currency"),
                      ),
                    );

                    return;
                  }
                  try {
                    final prefs = Get.find<PreferencesDao>();

                    await prefs.updateDefaultCurrency(currency!);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
