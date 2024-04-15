import 'package:flutter/material.dart';
import 'package:langwiz/components/drawer_tile.dart';
import 'package:langwiz/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // Header
          const DrawerHeader(
            child: Icon(Icons.edit, size: 45,),
          ),

          // Notes tile
          DrawerTile(
            leading: const Icon(Icons.home),
            title: 'Notes',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),

          // Settings tile
          DrawerTile(
            leading: const Icon(Icons.settings),
            title: 'Settings',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
