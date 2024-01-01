import 'package:flutter/material.dart';

class NCAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NCAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      centerTitle: true,
      // automaticallyImplyLeading: true,
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      // leading: const DrawerButton(),
      // const Icon(
      //   Icons.sort,
      //   color: Color(0xff212435),
      //   size: 24,
      // ),
      actions: [
        const Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: Icon(Icons.notifications, color: Color(0xff212435), size: 24),
        ),
      ],
      title: const Text(
        "NearbyCross",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          color: Color(0xffffffff),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
