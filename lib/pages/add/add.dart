import 'dart:convert';
import 'dart:ui';

import 'package:currency_picker/currency_picker.dart';
import 'package:expense_tracker/database/daos/person_dao.dart';
import 'package:expense_tracker/database/models/models.dart';
import 'package:expense_tracker/pages/add_label.dart';
import 'package:expense_tracker/pages/add_person.dart';
import 'package:expense_tracker/services/expense_service/expense_service.dart';
import 'package:expense_tracker/widgets/person.dart';
import 'package:expense_tracker/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;

import '../../database/daos/label_dao.dart';
import '../../database/daos/preferences_dao.dart';
import '../../database/database.dart';

import '../../helpers/hex_string_to_color.dart';
import '../../services/expense_service/models.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Currency? _currency;
  Importance? importance;
  List<Label> selectedLabels = [];

  final fq.QuillController _notesController = fq.QuillController.basic();

  Person? selectedPerson;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final currency = await Get.find<PreferencesDao>().getDefaultCurrency();
      setState(() {
        _currency = currency;
      });
    });
    super.initState();
  }

  // Render heading
  SliverToBoxAdapter heading(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    await ExpenseService.add(
      InsertExpenseOrTransaction(
        title: "Test",
        amount: 100,
        notes: jsonEncode(_notesController.document.toDelta().toJson()),
        importance: importance,
        date: DateTime.now(),
        person: selectedPerson?.id,
        labels: selectedLabels,
      ),
    );

    if (context.mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text("Add Expense"),
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: TitleEntry()),
          heading("Amount"),
          SliverToBoxAdapter(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration(
                icon: Column(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showCurrencyPicker(
                          context: context,
                          onSelect: (currency) {
                            setState(() {
                              _currency = currency;
                            });
                          },
                        );
                      },
                      icon: _currency != null
                          ? Text(
                              _currency!.symbol,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontFamily: "Manrope",
                                fontVariations: const [
                                  FontVariation("wght", 500),
                                ],
                              ),
                            )
                          : const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 2)
                  ],
                ),
                border: InputBorder.none,
              ),
            ),
          )),
          SliverToBoxAdapter(
            child: PersonChooseWidget(
              onSelectPerson: (person) {
                if (selectedPerson == person) {
                  setState(() {
                    selectedPerson = null;
                  });
                } else {
                  setState(() {
                    selectedPerson = person;
                  });
                }
              },
              selectedPersonId: selectedPerson?.id ?? "",
            ),
          ),
          heading("Importance"),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text("Essential"),
                        selected: importance == Importance.essential,
                        onSelected: selectedPerson == null
                            ? (_) {
                                setState(() {
                                  importance = Importance.essential;
                                });
                              }
                            : null,
                      ),
                      ChoiceChip(
                        label: const Text("Desire"),
                        selected: importance == Importance.desire,
                        onSelected: selectedPerson == null
                            ? (_) {
                                setState(() {
                                  importance = Importance.desire;
                                });
                              }
                            : null,
                      ),
                      ChoiceChip(
                        label: const Text("Waste"),
                        selected: importance == Importance.waste,
                        onSelected: selectedPerson == null
                            ? (_) {
                                setState(() {
                                  importance = Importance.waste;
                                });
                              }
                            : null,
                      ),
                      ChoiceChip(
                        label: const Text("Investment"),
                        selected: importance == Importance.investment,
                        onSelected: selectedPerson == null
                            ? (_) {
                                setState(() {
                                  importance = Importance.investment;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                )),
          ),
          heading("Labels"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder<List<Label>>(
                stream: Get.find<LabelDao>().watchAllLabels(),
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final label in snapshot.data!)
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.fromSeed(
                              seedColor: label.color.toColor(),
                            ),
                          ),
                          child: Builder(builder: (newContext) {
                            return ChoiceChip(
                              label: Text(label.name),
                              labelStyle: TextStyle(
                                color: MaterialStateColor.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Theme.of(newContext)
                                        .colorScheme
                                        .onBackground;
                                  } else {
                                    return Theme.of(context)
                                        .colorScheme
                                        .onSurface;
                                  }
                                }),
                              ),
                              selected: selectedLabels.contains(label),
                              onSelected: (state) {
                                if (state) {
                                  setState(() {
                                    selectedLabels.add(label);
                                  });
                                } else {
                                  setState(() {
                                    selectedLabels.remove(label);
                                  });
                                }
                              },
                            );
                          }),
                        ),
                      ActionChip(
                        avatar: const Icon(Icons.add),
                        label: const Text("Add"),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddLabelPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          heading("Notes"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [TextBox(controller: _notesController)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleEntry extends StatelessWidget {
  const TitleEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: TextField(
        style: Theme.of(context).textTheme.titleLarge,
        decoration: InputDecoration(
          hintText: "Title",
          hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class PersonChooseWidget extends StatelessWidget {
  const PersonChooseWidget({
    super.key,
    required this.onSelectPerson,
    required this.selectedPersonId,
  });

  final String selectedPersonId;
  final void Function(Person person) onSelectPerson;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OpenContainer(
                  closedColor: Theme.of(context).cardColor,
                  openColor: Theme.of(context).cardColor,
                  transitionType: ContainerTransitionType.fadeThrough,
                  openBuilder: ((context, _) => const AddPersonPage()),
                  closedBuilder: ((context, action) {
                    return Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              action();
                            },
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(height: 5),
                          Hero(
                            tag: "Add_Person",
                            child: Text(
                              "Add Person",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: StreamBuilder<List<Person>>(
                    stream: Get.find<PersonDao>().watchAllPersons(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return PersonWidget(
                              person: snapshot.data![index],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              selected:
                                  selectedPersonId == snapshot.data![index].id,
                              onSelect: onSelectPerson,
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return const SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
