import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as fq;
import 'dart:ui';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';

class TextBox extends StatelessWidget {
  TextBox({
    super.key,
    required this.controller,
  });

  fq.QuillController controller;
  FocusNode quillFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        fq.QuillToolbar.basic(
          controller: controller,
          multiRowsDisplay: false,
          showBackgroundColorButton: false,
          showFontSize: false,
          showFontFamily: false,
          showStrikeThrough: false,
          showColorButton: false,
          showClearFormat: false,
          showAlignmentButtons: false,
          showIndent: false,
        ),
        EnsureVisibleWhenFocused(
          focusNode: quillFocusNode,
          // onTapInside: (_) {
          //   Focus.of(context).requestFocus(quillFocusNode);
          // },
          // onTapOutside: (_) {
          //   Focus.of(context).unfocus();
          // },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: quillFocusNode.hasFocus
                      ? colorScheme.primary
                      : colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: fq.QuillEditor(
              controller: controller,
              readOnly: false,
              scrollable: false,
              autoFocus: false,
              expands: false,
              focusNode: quillFocusNode,
              scrollController: ScrollController(),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              placeholder: "Notes",
              customStyles: fq.DefaultStyles(
                placeHolder: fq.DefaultTextBlockStyle(
                  TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15.5,
                    fontFamily: "Manrope"
                  ),
                  const fq.VerticalSpacing(0, 0),
                  const fq.VerticalSpacing(0, 0),
                  null,
                ),
                code: fq.DefaultTextBlockStyle(
                  TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontFamily: "Recursive",
                    fontVariations: const [
                      FontVariation("MONO", 1),
                    ],
                  ),
                  const fq.VerticalSpacing(0, 0),
                  const fq.VerticalSpacing(0, 0),
                  BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
