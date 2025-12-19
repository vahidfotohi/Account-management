import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget>? children;
  final Widget? child;

  const SectionCard(
      {super.key,
      required this.title,
      required this.icon,
       this.children,this.child,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: Colors.grey[700], fontWeight: FontWeight.bold,),),
            ],
          ),
        ),
        Card(
            child: Padding(padding: const EdgeInsets.all(16), child: child),),
      ],
    );
  }
}
