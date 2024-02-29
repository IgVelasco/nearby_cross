import 'package:flutter/material.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross_example/screens/comunication_screen.dart';
import 'package:nearby_cross_example/viewmodels/select_interaction_viewmodel.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';
import 'package:nearby_cross_example/widgets/utils/alert.dart';
import 'package:provider/provider.dart';

class SelectInteractionScreen extends StatelessWidget {
  const SelectInteractionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void disconnectAction(Device device) {
      // TODO
      return;
    }

    void interactAction(Device device) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ComunicationScreen(device: device)));
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SelectInteractionViewModel())
      ],
      builder: (context, child) {
        var provider =
            Provider.of<SelectInteractionViewModel>(context, listen: false);

        bool noConnections = provider.getTotalConnectionsCount() == 0;

        return Scaffold(
            appBar: NCAppBar(),
            body: Consumer<SelectInteractionViewModel>(
              builder: (context, viewModel, child) => RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () => provider.refreshConnectedList(),
                  child: noConnections
                      ? LayoutBuilder(
                          builder: (context, constraints) => Center(
                            child: SizedBox(
                              height: constraints.maxHeight * 0.2,
                              width: constraints.maxWidth * 0.8,
                              child: const Alert(
                                icon: Icon(Icons.warning),
                                title: "No connections",
                                text:
                                    "Please start to advertise or discover to find devices to interact!",
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
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
  final Function(Device) acceptAction;
  final Function(Device) rejectAction;

  const InteractListItem(
      {super.key,
      required this.device,
      required this.acceptAction,
      required this.rejectAction});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text(device.endpointName)),
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
                        acceptAction(device);
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
        ));
  }
}
