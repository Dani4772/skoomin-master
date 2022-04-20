import 'package:flutter/cupertino.dart';
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

class FutureDropDownWidget<T> extends StatefulWidget {
  const FutureDropDownWidget({
    Key? key,
    required this.dataFunction,
    required this.value,
    this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final Future<List<T>> Function() dataFunction;
  final T? value;
  final String? hintText;
  final void Function(T) onChanged;

  @override
  _FutureDropDownWidgetState<T> createState() =>
      _FutureDropDownWidgetState<T>();
}

class _FutureDropDownWidgetState<T> extends State<FutureDropDownWidget<T>> {
  T? _value;
  var _items = <T>[];
  var _isLoading = true;
  var _canSelect=false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant FutureDropDownWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchData();
  }

  void _fetchData() async {
    _canSelect=false;
    _items = await widget.dataFunction();
    _value = widget.value;
    _isLoading = false;
    _canSelect=true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<T>(
        hint: Text(widget.hintText ?? 'Please select type'),
        isExpanded: true,
        value: _value,
        icon: _isLoading
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.arrow_drop_down),
        items: _items
            .map(
              (e) => DropdownMenuItem(
                child: Text(e.toString()),
                value: e,
              ),
            )
            .toList(),
        onChanged: (value) {
          if (!_canSelect) {
            return;
          }
          _value = value;
          setState(() {});
          widget.onChanged(_value!);
        },
        underline: const SizedBox(),
      ),
    );
  }
}
