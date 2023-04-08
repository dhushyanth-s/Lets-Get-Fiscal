import 'package:expense_tracker/database/database.dart';
import 'package:flutter/material.dart';

class PersonWidget extends StatefulWidget {
  const PersonWidget({
    super.key,
    required this.person,
    this.margin,
    this.onSelect,
    this.selected = false,
  });

  final Person person;
  final EdgeInsets? margin;
  final void Function(Person person)? onSelect;
  final bool selected;

  @override
  State<PersonWidget> createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onSelect != null) {
          widget.onSelect!(widget.person);
        }
      },
      child: AnimatedContainer(
        height: 100,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: widget.selected
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(milliseconds: 150),
        margin: widget.margin,
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: widget.person.image != null
                  ? MemoryImage(widget.person.image!)
                  : null,
              child:
                  widget.person.image != null ? null : const Icon(Icons.person),
            ),
            const SizedBox(height: 5),
            Text(
              widget.person.name,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: widget.selected
                        ? Theme.of(context).colorScheme.onSecondaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
