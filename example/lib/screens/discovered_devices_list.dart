import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_viewmodel.dart';
import 'package:nearby_cross_example/widgets/discovered_list_item.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';

class DiscoveredDevicesList extends StatelessWidget {
  static final logger = Logger();
  final DiscovererViewModel provider;
  const DiscoveredDevicesList(this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Connect to an Advertiser",
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
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  itemCount: provider.getDiscoveredDevicesAmount(),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    Device device = provider.getDiscoveredDevices()[index];
                    return DiscoveredListItem(device, provider);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
