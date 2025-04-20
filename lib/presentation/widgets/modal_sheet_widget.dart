import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ModalSheetWidget extends HookWidget {
  const ModalSheetWidget({
    super.key,
    required this.notes,
    required this.images,
    required this.index,
    this.onEnd,
  });

  final List<String?> notes;
  final List<XFile?> images;
  final VoidCallback? onEnd;
  final int index;

  @override
  Widget build(BuildContext context) {
    final noteController = useTextEditingController(text: notes[index]);
    final image = useState<XFile?>(images[index]);
    return Container(
      height: 600,
      padding: const EdgeInsets.all(20).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add Notes / Image",
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          TextField(
            controller: noteController,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(labelText: "Notes"),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.image),
            label: const Text("Pick Image"),
            onPressed: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (picked != null) {
                image.value = picked;
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              notes[index] = noteController.text.trim().isEmpty ? null : noteController.text;
              images[index] = image.value;
              Navigator.pop(context);
              onEnd?.call();
            },
          )
        ],
      ),
    );
  }
}
