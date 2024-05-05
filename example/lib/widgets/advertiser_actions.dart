import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross_example/screens/pending_connections_list.dart';
import 'package:nearby_cross_example/screens/select_interaction_screen.dart';
import 'package:nearby_cross_example/viewmodels/advertiser_viewmodel.dart';
import 'package:provider/provider.dart';

class AdvertiserActions extends StatelessWidget {
  final String? username;
  final NearbyStrategies? strategy;
  const AdvertiserActions(this.username, this.strategy, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdvertiserViewModel())
      ],
      builder: (context, child) {
        Provider.of<AdvertiserViewModel>(context, listen: false).setDeviceInfo(
            username != null ? utf8.encode(username!) : Uint8List(0), false);

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
              Consumer<AdvertiserViewModel>(
                builder: (context, app, child) => SwitchListTile(
                  value: app.manualAcceptConnections,
                  activeColor: Colors.blue,
                  title: const Text(
                    "Manual accept",
                  ),
                  onChanged: (value) => app.isAdvertising
                      ? null
                      : app.toggleManualAcceptConnections(),
                ),
              ),
              Consumer<AdvertiserViewModel>(
                builder: (context, app, child) => SwitchListTile(
                  value: app.isAdvertising,
                  activeColor: Colors.blue,
                  title: const Text(
                    "Advertise",
                  ),
                  onChanged: (value) => value == false
                      ? app.stopAdvertising()
                      : app.startAdvertising(strategy!),
                ),
              ),
              const Divider(
                color: Color(0x4d9e9e9e),
                height: 16,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Consumer<AdvertiserViewModel>(
                  builder: (context, viewmodel, child) => ListTile(
                        tileColor: const Color(0x1fffffff),
                        title: Text(
                          "Pending connections${viewmodel.getPendingConnectionsCount() > 0 ? " (${viewmodel.getPendingConnectionsCount()})" : ""}",
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const PendingConnectionsList(),
                          ));
                        },
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xff212435), size: 24),
                      )),
              ListTile(
                tileColor: const Color(0x1fffffff),
                title: const Text(
                  "Interact",
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SelectInteractionScreen(),
                  ));
                },
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xff212435), size: 24),
              )
            ],
          ),
        ]);
      },
    );
  }
}
