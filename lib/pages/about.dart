import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
    required this.appName,
    required this.author,
    required this.version,
    required this.notes,
  });

  final String appName;
  final String author;
  final String version;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.apps_rounded, size: 32),
                  // TODO: Replace with your own app icon widget.
                  // Example: child: Image.asset('assets/icon/app_icon.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appName, style: textTheme.headlineSmall),
                      const SizedBox(height: 10),
                      _AboutInfoLine(label: '作者', value: author),
                      const SizedBox(height: 6),
                      _AboutInfoLine(label: '版本', value: version),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notes
                .map(
                  (note) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $note', style: textTheme.bodyMedium),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _AboutInfoLine extends StatelessWidget {
  const _AboutInfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          '$label: ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }
}
