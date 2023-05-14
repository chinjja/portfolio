import 'package:flutter/material.dart';

class LinkTitle extends StatelessWidget {
  const LinkTitle(
    this.title, {
    Key? key,
    required this.parent,
    this.color = Colors.black,
  }) : super(key: key);

  final String title;
  final Color color;
  final BuildContext parent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, right: 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Icon(
              Icons.link,
              color: color,
              size: 40,
            ),
            onTap: () {
              Scrollable.ensureVisible(
                parent,
                duration: const Duration(milliseconds: 250),
              );
            },
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
