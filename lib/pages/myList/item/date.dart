import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyListItemDate extends StatefulWidget {
  final String keyMap;
  final String dateTime;
  final void Function({
    required String key,
    required dynamic value,
  }) callback;

  const MyListItemDate({
    super.key,
    required this.keyMap,
    required this.dateTime,
    required this.callback,
  });

  @override
  State<MyListItemDate> createState() => _MyListItemDateState();
}

class _MyListItemDateState extends State<MyListItemDate> {
  final date = TextEditingController();

  @override
  void initState() {
    super.initState();
    date.text = widget.dateTime;
  }

  @override
  void dispose() {
    super.dispose();
    date.dispose();
  }

  Future<void> datePicker() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dateTime != null) {
      final dateReal = DateFormat.yMMMMd().format(dateTime);

      setState(() {
        date.text = dateReal;
      });

      widget.callback(
        key: widget.keyMap,
        value: dateReal,
      );
    }
  }

  void dateNow() {
    final dateReal = DateFormat.yMMMMd().format(DateTime.now());

    setState(() {
      date.text = dateReal;
    });

    widget.callback(
      key: widget.keyMap,
      value: dateReal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextField(
            controller: date,
            keyboardType: TextInputType.none,
            textAlign: TextAlign.center,
            showCursor: false,
            onTap: datePicker,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "Select date",
            ),
          ),
        ),
        TextButton(
          onPressed: dateNow,
          child: const Text("Today"),
        ),
      ],
    );
  }
}
