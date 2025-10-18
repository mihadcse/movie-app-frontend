import 'package:flutter/material.dart';

class SaveToSelectionSheet extends StatefulWidget {
  const SaveToSelectionSheet({super.key});

  @override
  State<SaveToSelectionSheet> createState() => _SaveToSelectionSheetState();
}

class _SaveToSelectionSheetState extends State<SaveToSelectionSheet> {
  String? _selectedOption; // To hold the selected option: 'favorites' or 'watch_later'

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Save To', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          RadioListTile<String>(
            title: const Text('Favorites'),
            value: 'favorites',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Watch later'),
            value: 'watch_later',
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Functionality for "New Collection" will be added later if requested
              },
              icon: const Icon(Icons.add),
              label: const Text('New Collection'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedOption); // Pass the selected option back
              },
              child: const Text('Done'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
