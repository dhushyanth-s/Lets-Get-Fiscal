import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerField extends StatelessWidget {
  const ColorPickerField({
    super.key,
    required this.color,
    required this.onColorChosen,
  });

  final Color color;
  final Function(Color color) onColorChosen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      title: Text(ColorTools.nameThatColor(color)),
      trailing: ColorIndicator(
        color: color,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      onTap: () async {
        final newColor = await showColorPickerDialog(
          context,
          color,
          subheading: const Text("Shades"),
          pickersEnabled: {
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
            ColorPickerType.wheel: true,
            ColorPickerType.custom: true,
          },
          showColorName: true,
          dialogTitle: const Text("Pick a Color"),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          pickerTypeLabels: {
            ColorPickerType.primary: "Presets",
            ColorPickerType.wheel: "Custom",
          },
          pickerTypeTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
        );
        onColorChosen(newColor);
      },
    );
  }
}
