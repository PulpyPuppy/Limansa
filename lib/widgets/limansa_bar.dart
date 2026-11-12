import 'package:flutter/material.dart';

class LimansaBar extends StatelessWidget implements PreferredSizeWidget {
  const LimansaBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text.rich(
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: Offset(3.0, 3.0),
              blurRadius: 3.0,
              color: Theme.of(context).colorScheme.shadow,
            ),
          ],
        ),
        TextSpan(
          children: const <TextSpan>[
            TextSpan(
              text: 'LIMANSA',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: '=>Hacker News',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
