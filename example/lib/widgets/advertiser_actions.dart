import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_model.dart';
import '../screens/advertiser_comunication_screen.dart';
import '../screens/advertising_list.dart';

class AdvertiserActions extends StatelessWidget {
  const AdvertiserActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          const Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Consumer<AppModel>(
            builder: (context, app, child) => SwitchListTile(
              value: app.isAdvertising,
              title: const Text(
                "Advertise",
              ),
              onChanged: (value) => app.toggleAdvertising(),
            ),
          ),
          const Divider(
            color: Color(0x4d9e9e9e),
            height: 16,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Consumer<AppModel>(
              builder: (context, app, child) => app.isAdvertising
                  ? Wrap(children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AdvertiserList(),
                          ));
                        },
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xff212435), size: 24),
                        title: const Text(
                          "Pending Devices",
                        ),
                      ),
                      const Divider(
                        color: Color(0x4d9e9e9e),
                        height: 16,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                      ),
                    ])
                  : Container()),
          Consumer<AppModel>(
              builder: (context, app, child) => ListTile(
                    tileColor: const Color(0x1fffffff),
                    title: const Text(
                      "Interact",
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdvertiserComunicationScreen(),
                      ));
                    },
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Color(0xff212435), size: 24),
                  ))
        ],
      ),
      Consumer<AppModel>(
          builder: (context, app, child) => app.connected
              ? MaterialButton(
                  onPressed: () {
                    Provider.of<AppModel>(context, listen: false).disconnect();
                  },
                  color: const Color(0x343a57e8),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: const Color(0xff3a57e8),
                  height: 40,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Disconnect All",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              : Container())
    ]);
  }
}
