import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MarkdownPage extends ConsumerWidget {
  const MarkdownPage({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path.substring(path.lastIndexOf('/') + 1)),
      ),
      body: FutureBuilder<String>(
          future: rootBundle.loadString(path),
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Markdown(
              data: data,
              selectable: true,
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrlString(href);
                }
              },
            );
          }),
    );
  }
}
