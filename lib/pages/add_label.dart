import 'dart:convert';

import 'package:expense_tracker/database/daos/label_dao.dart';
import 'package:expense_tracker/database/database.dart';
import 'package:expense_tracker/widgets/color_picker.dart';
import 'package:expense_tracker/widgets/text_box.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:get/get.dart';

class AddLabelPage extends StatefulWidget {
  const AddLabelPage({super.key});

  @override
  State<AddLabelPage> createState() => _AddLabelPageState();
}

class _AddLabelPageState extends State<AddLabelPage> {
  final _notesCOntroller = fq.QuillController.basic();
  Color color = Colors.green;
  bool _saved = false;
  bool _changed = false;
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _notesCOntroller.document.changes.listen((change) {
      _changed = true;
    });
  }

  showConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Discard changes?"),
          content: const Text("Are you sure you want to discard changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveLabel() async {
    if (_formKey.currentState!.validate()) {
      final labelDao = Get.find<LabelDao>();
      await labelDao.insertLabel(
        LabelsCompanion.insert(
          name: _nameController.text,
          color: color.hex,
          notes: jsonEncode(
            _notesCOntroller.document.toDelta().toJson(),
          ),
        ),
      );
      _saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onWillPop: () async {
        if (_changed && _saved) {
          return true;
        } else if (_changed && !_saved) {
          return await showConfirmationDialog(context);
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Label'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (!_changed) return;

                try {
                  await saveLabel();
                  // ignore: use_build_context_synchronously
                  if (!context.mounted) return;
                  Navigator.of(context).maybePop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onChanged: (_) {
                    _changed = true;
                  },
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                ColorPickerField(
                    color: color,
                    onColorChosen: (newColor) {
                      _changed = true;
                      setState(() {
                        color = newColor;
                      });
                    }),
                const SizedBox(height: 15),
                TextBox(controller: _notesCOntroller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
