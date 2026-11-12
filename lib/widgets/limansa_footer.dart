import 'package:flutter/material.dart';
import '../models/feed_type.dart';

class LimansaFooter extends StatelessWidget {
  final FeedType feed;
  final ValueChanged<FeedType> onSelect;

  const LimansaFooter({
    super.key,
    required this.feed,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: FeedType.values.map((type) {
            final isSelected = type == feed;
            final style = ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            );

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: isSelected
                    ? FilledButton(
                        style: style,
                        onPressed: () => onSelect(type),
                        child: Text(type.label),
                      )
                    : OutlinedButton(
                        style: style,
                        onPressed: () => onSelect(type),
                        child: Text(type.label),
                      ),
              ),
            );
          }).toList()
        ),
      ),
    ); // SafeArea
  }
}
