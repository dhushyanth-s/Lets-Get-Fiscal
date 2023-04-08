import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageSelector extends StatefulWidget {
  ImageSelector({
    super.key,
    required this.onImageSelected,
  });

  Function(Uint8List?) onImageSelected;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );
        if (result != null) {
          PlatformFile file = result.files.first;
          setState(() {
            imageBytes = file.bytes;
          });
          widget.onImageSelected(file.bytes);
        }
      },
      icon: imageBytes != null
          ? CircleAvatar(
              backgroundImage: MemoryImage(imageBytes!),
              radius: 70,
            )
          : const Icon(Icons.add),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(70, 70)),
        // iconSize: MaterialStateProperty.all(50),
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.primary,
        ),
        iconColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.onPrimary,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
        ),
      ),
    );
  }
}
