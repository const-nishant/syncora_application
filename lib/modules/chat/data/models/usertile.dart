import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String username;
  final void Function() onTap;
  const UserTile({
    super.key,
    required this.username,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(width: 16.0),
            Text(
              username,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
