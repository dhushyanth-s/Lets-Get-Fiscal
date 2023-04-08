import 'dart:convert';
import 'dart:typed_data';

import 'package:expense_tracker/database/daos/person_dao.dart';
import 'package:expense_tracker/widgets/image_selector.dart';
import 'package:expense_tracker/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'package:get/get.dart';
import 'package:drift/drift.dart' as dr;

import '../database/database.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final controller = fq.QuillController.basic();

  bool isSaved = false;
  late String name;
  Uint8List? image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onWillPop: () async {
        if (_formKey.currentState!.validate() && !isSaved) {
          final bool choice = await Get.dialog(AlertDialog(
            title: Text("Discard Changes?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(canPop: false, result: false);
                },
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Get.back(canPop: true, result: true);
                },
                child: Text("Yes"),
              ),
            ],
          ));
          return choice;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Hero(
            tag: "Add_Person",
            child: Text("Add Person"),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  if (_formKey.currentState!.validate()) {
                    final person = PeopleCompanion.insert(
                      name: name,
                      notes: dr.Value(
                        jsonEncode(
                          controller.document.toDelta().toJson(),
                        ),
                      ),
                      image: dr.Value(image),
                    );
                    final PersonDao personDao = Get.find();
                    await personDao.insertPerson(person);
                    setState(() {
                      isSaved = true;
                    });
                    Get.back(canPop: true);
                  }
                } catch (e) {
                  Get.showSnackbar(
                      Get.snackbar("Error", e.toString()).snackbar);
                }
              },
              child: const Text("Save"),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ImageSelector(
                  onImageSelected: (image) {
                    this.image = image;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                const SizedBox(height: 20),
                TextBox(
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
