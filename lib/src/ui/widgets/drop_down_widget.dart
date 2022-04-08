import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final String? select;
  final List<String>? list;
  final Function(String?) onChanged;
  final String? hintText;

  const DropDownWidget({
    Key? key,
    this.hintText,
    required this.select,
    required this.list,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        hint: Text(widget.hintText ?? 'Please select type'),
        isExpanded: true,
        value: widget.select,
        items: widget.list!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: widget.onChanged,
        underline: const SizedBox(),
      ),
    );
  }
}
