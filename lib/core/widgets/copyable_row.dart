import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableRow extends StatelessWidget {
  final String title;
  final String value;
  const CopyableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کپی شد'), duration: Duration(seconds: 1)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 8),
            Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Courier', fontSize: 15, fontWeight: FontWeight.bold))),
            const Icon(Icons.copy, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
