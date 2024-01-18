import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_model.dart';
import '../screens/advertising_list.dart';
import '../screens/discoverer_comunication_screen.dart';

class DiscovererActions extends StatelessWidget {
  const DiscovererActions({super.key});

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
              value: app.isDiscovering,
              title: const Text(
                "Discovery",
              ),
              onChanged: (value) =>
                  {value == false ? app.stopDiscovery() : app.startDiscovery()},
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
              builder: (context, app, child) => app.isDiscovering
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
                          "Search Devices",
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
              builder: (context, app, child) => app.connected
                  ? ListTile(
                      tileColor: const Color(0x1fffffff),
                      title: Text(
                        "Connected: Username ${app.connectedAdvertiser["endpointName"]}",
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DiscovererComunicationScreen(
                              advertiser: app.connectedAdvertiser),
                        ));
                      },
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xff212435), size: 24),
                    )
                  : const ListTile(
                      tileColor: Color(0x1fffffff),
                      title: Text(
                        "No Connected Device",
                      ),
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
                    "Disconnect",
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
