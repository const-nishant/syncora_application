import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_exports.dart';
import '../widgets/postwidget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    Provider.of<WalletProvider>(context, listen: false).loadWalletData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  Text("Hello!!, [name]"),
                  Container(
                    width: 50, // Set width
                    height:
                        50, // Set height (same as width for a perfect circle)
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Border color
                        width: 2.0, // Border thickness
                      ),
                    ),
                    child: IconButton(
                      iconSize: 24, // Adjust icon size inside the button
                      icon: Icon(
                        Icons.notifications,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(height: 20),
              Text(
                "Feed",
                style: TextStyle(fontSize: 24),
              ),
              // PostWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          LucideIcons.messageCircle,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onPressed: () {},
      ),
    );
  }
}
