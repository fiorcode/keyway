import 'package:flutter/material.dart';

class SearchBarTextField extends StatefulWidget {
  SearchBarTextField(
    this.ctrler,
    this.searchFunction,
    this.switchFunction,
    this.clearFunction,
    this.focus,
  );

  final TextEditingController ctrler;
  final Function searchFunction;
  final Function clearFunction;
  final Function switchFunction;
  final FocusNode focus;

  @override
  _SearchBarTextFieldState createState() => _SearchBarTextFieldState();
}

class _SearchBarTextFieldState extends State<SearchBarTextField> {
  bool _empty = true;

  void _onChange() {
    setState(() => _empty = widget.ctrler.text.isEmpty);
    widget.searchFunction();
  }

  @override
  void initState() {
    _empty = widget.ctrler.text.isEmpty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      controller: widget.ctrler,
      focusNode: widget.focus,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: InkWell(
          child: Icon(Icons.search),
          onTap: widget.switchFunction as void Function()?,
        ),
        suffixIcon: _empty
            ? null
            : InkWell(
                child: Icon(Icons.clear),
                onTap: widget.clearFunction as void Function()?,
              ),
      ),
      onChanged: (_) => _onChange(),
    );
  }
}
