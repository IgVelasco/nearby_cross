import 'package:flutter/material.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross_example/screens/broadcast_screen.dart';
import 'package:nearby_cross_example/screens/comunication_screen.dart';
import 'package:nearby_cross_example/viewmodels/select_interaction_viewmodel.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';
import 'package:nearby_cross_example/widgets/utils/alert.dart';
import 'package:provider/provider.dart';

class SelectInteractionScreen extends StatelessWidget {
  const SelectInteractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SelectInteractionViewModel())
      ],
      builder: (context, child) {
        var provider =
            Provider.of<SelectInteractionViewModel>(context, listen: true);

        void disconnectAction(Device device) async {
          await provider.disconnectFrom(device);
        }

        void interactAction(Device device, String deviceName) async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ComunicationScreen(
                        device: device,
                        deviceName: deviceName,
                      )))
              .then((value) {
            return provider.afterNavigationPop();
          });
        }

        List<Widget> actions = <Widget>[
          IconButton(
            onPressed: () async => await Navigator.of(context)
                .push(
                    MaterialPageRoute(builder: (context) => BroadcastScreen()))
                .then((value) {
              return provider.afterNavigationPop();
            }),
            icon: const Icon(Icons.campaign),
          )
        ];

        bool noConnections = provider.getTotalConnectionsCount() == 0;

        return Scaffold(
            appBar: NCAppBar(
              title: "Interact",
              actions: actions,
            ),
            body: Consumer<SelectInteractionViewModel>(
              builder: (context, viewModel, child) => noConnections
                  ? const Center(
                      child: Alert(
                        icon: Icon(
                          Icons.warning,
                          size: 40,
                        ),
                        title: "No connections",
                        message:
                            "Please start to advertise or discover to find devices to interact!", // Example long message
                      ),
                    )
                  : RefreshIndicator(
                      triggerMode: RefreshIndicatorTriggerMode.onEdge,
                      onRefresh: () => provider.refreshConnectedList(),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(0),
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: viewModel.getTotalConnectionsCount(),
                        itemBuilder: (context, index) {
                          Device device =
                              viewModel.getConnectedDeviceByIndex(index);
                          return InteractListItem(
                              device: device,
                              deviceName:
                                  viewModel.getEndpointNameFromDevice(device),
                              acceptAction: interactAction,
                              rejectAction: disconnectAction);
                        },
                      )),
            ));
      },
    );
  }
}

class InteractListItem extends StatelessWidget {
  final Device device;
  final String deviceName;
  final Function(Device, String) acceptAction;
  final Function(Device) rejectAction;

  const InteractListItem(
      {super.key,
      required this.device,
      required this.deviceName,
      required this.acceptAction,
      required this.rejectAction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text(deviceName)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () {
                            rejectAction(device);
                          },
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.phonelink_erase),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 5,
                          indent: 20,
                          endIndent: 0,
                        ),
                        FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () {
                            acceptAction(device, deviceName);
                          },
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.chat),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ...(device.hasNewMessages
            ? [
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      )),
                )
              ]
            : [])
      ],
    );
  }
}
