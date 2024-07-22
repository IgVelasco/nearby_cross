import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross_example/viewmodels/pending_connections_viewmodel.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';
import 'package:nearby_cross_example/widgets/pending_connection_list_item.dart';
import 'package:provider/provider.dart';

class PendingConnectionsList extends StatelessWidget {
  static final logger = Logger();
  const PendingConnectionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PendingConnectionsViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: NCAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 20),
                  child: Text(
                    "Pending connections",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 24,
                      color: Color(0xff272727),
                    ),
                  ),
                ),
                Consumer<PendingConnectionsViewModel>(
                  builder: (context, provider, child) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(0),
                      itemCount: provider.getPendingConnectionsCount(),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        var device =
                            provider.getPendingConnectionsDevices()[index];
                        return PendingConnectionListItem(
                          deviceName:
                              provider.getEndpointNameFromDevice(device),
                          acceptAction: () {
                            return provider.acceptConnection(device.endpointId);
                          },
                          rejectAction: () {
                            return provider.rejectConnection(device.endpointId);
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
