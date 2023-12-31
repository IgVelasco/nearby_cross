import 'package:flutter/material.dart';
import 'package:nearby_cross_example/screens/main_screen.dart';

class NCDrawer extends StatelessWidget {
  const NCDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('Discoverer'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MainScreen(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.train,
            ),
            title: const Text('Advertiser'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
