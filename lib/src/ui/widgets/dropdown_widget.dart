// ignore_for_file: must_be_immutable

import 'dart:core';

import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  DropDownWidget({
    Key? key,
    required this.after,
    required this.callBack,
    required this.index,
    required this.items,
    required this.type,
    required this.values,
    required this.len,
    required this.key2,
  }) : super(key: key);

  final GlobalKey<AnimatedListState> key2;
  final String type;
  final int index;
  final List<String> items;
  int len;
  final Function after;

  //String to get selected value - 1st bool - secret enabled - 2nd bool _enabled - _key - len
  final Function(
    String,
    TextEditingController,
    bool,
    bool,
    GlobalKey<AnimatedListState>,
    int,
  ) callBack;
  final List<String?> values;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      hint: Text("Please Select your " + widget.type),
      value: widget.values[widget.index],
      items: widget.items
          .map(
            (region) => DropdownMenuItem(
              child: Text(region),
              value: region,
            ),
          )
          .toList(),
      onChanged: (val) {
        setState(() => widget.values[widget.index] = val as String?);
        // widget.secretEnabled = false;


        for (int i = widget.index + 1; i < widget.values.length; i++) {
          widget.values[i] = null;
        }
        // _secretCodeController.text = "";
        // _enabled = false;

        if (widget.len <= widget.index + 1) {
          // print(_len);
          widget.key2.currentState?.insertItem(widget.index + 1);
          widget.len++;
        }
        //String to get selected value - 1st bool - secret enabled - 2nd bool _enabled - _key - len
        widget.callBack(
          widget.values[widget.index] ?? '',
          TextEditingController(),
          false,
          false,
          widget.key2,
          widget.len,
        );
        widget.after();
      },
    );
  }
}
