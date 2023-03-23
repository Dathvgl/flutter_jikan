import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';

class DiscussionClubDialog extends StatelessWidget {
  final String openText;
  final String labelText;
  final String submitText;
  final void Function(String text) onPressed;

  const DiscussionClubDialog({
    super.key,
    required this.openText,
    required this.labelText,
    required this.submitText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: "");

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Text(openText),
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Alert Dialog Form"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(labelText),
                      floatingLabelStyle: const TextStyle(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        onPressed(textController.text);
                        context.pop();
                      },
                      child: Text(submitText),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
