import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DiscussionClubImage extends StatefulWidget {
  final String selectText;
  final void Function(File? value) onChanged;

  const DiscussionClubImage({
    super.key,
    required this.selectText,
    required this.onChanged,
  });

  @override
  State<DiscussionClubImage> createState() => _DiscussionClubImageState();
}

class _DiscussionClubImageState extends State<DiscussionClubImage> {
  File? image;

  final picker = ImagePicker();

  Future<void> openImagePicker() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
        widget.onChanged(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => openImagePicker(),
                child: Text(widget.selectText),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => setState(() {
                  image = null;
                }),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
          child: image != null
              ? Image.file(image!, fit: BoxFit.cover)
              : const Text(
                  'Please select an image',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
        )
      ],
    );
  }
}
