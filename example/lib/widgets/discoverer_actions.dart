import 'package:flutter/material.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_viewmodel.dart';
import 'package:provider/provider.dart';

import '../screens/advertising_list.dart';
import '../screens/discoverer_comunication_screen.dart';

class DiscovererActions extends StatelessWidget {
  final String? username;
  const DiscovererActions(this.username, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => DiscovererViewModel.withUsername(username))
        ],
        child: Column(children: [
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
              Consumer<DiscovererViewModel>(
                builder: (context, viewModel, child) => SwitchListTile(
                  value: viewModel.isDiscovering,
                  title: const Text(
                    "Discovery",
                  ),
                  onChanged: (value) => {
                    !value
                        ? viewModel.stopDiscovery()
                        : viewModel.startDiscovering()
                  },
                ),
              ),
              const Divider(
                color: Color(0x4d9e9e9e),
                height: 16,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
              Consumer<DiscovererViewModel>(
                  builder: (context, viewModel, child) =>
                      viewModel.isDiscovering
                          ? Wrap(children: [
                              ListTile(
                                onTap: () {
                                  // TODO: This will not update Discovered devices
                                  // when a new Device is discovered
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DiscoveredDevicesList(viewModel),
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
              Consumer<DiscovererViewModel>(
                  builder: (context, viewModel, child) => viewModel.isConnected
                      ? ListTile(
                          tileColor: const Color(0x1fffffff),
                          title: Text(
                            "Connected: Username ${viewModel.getConnectedDeviceName()}",
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DiscovererComunicationScreen(
                                      connectedDevice: viewModel
                                          .getConnectedDevice()!
                                          .toItem()),
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
          Consumer<DiscovererViewModel>(
              builder: (context, viewModel, child) => viewModel.isConnected
                  ? MaterialButton(
                      onPressed: () {
                        Provider.of<DiscovererViewModel>(context, listen: false)
                            .disconnect();
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
        ]));
  }
}
