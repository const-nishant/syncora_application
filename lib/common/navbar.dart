import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:syncora_application/modules/NFT/nftscreen.dart';
import 'package:syncora_application/modules/chat/screens/main_chatscreen.dart';
import 'package:syncora_application/modules/home/screen/homescreen.dart';
import 'package:syncora_application/modules/posts/post_screen.dart';
import 'package:syncora_application/modules/profile/screens/profilescreen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0; //currentindex = 0 then it will show homescreen

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Homescreen(), //0th index
    const MainChatscreen(), //1th index
    const PostScreen(), //2th index
    NFTScreen(), //3th index
    const Profilescreen(), //4th index
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: goToPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.globe),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ]),
    );
  }
}
