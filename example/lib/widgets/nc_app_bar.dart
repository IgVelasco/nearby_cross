import 'package:flutter/material.dart';

class NCAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  late final List<Widget> actions;

  NCAppBar({super.key, this.title = "NearbyCross", List<Widget>? actions}) {
    if (actions == null) {
      this.actions = const [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: Icon(Icons.notifications, color: Color(0xff212435), size: 24),
        ),
      ];
    } else {
      this.actions = actions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      centerTitle: true,
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      actions: actions,
      title: Text(
        title!,
        style: const TextStyle(
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
