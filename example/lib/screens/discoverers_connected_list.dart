import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_viewmodel.dart';
import 'package:nearby_cross_example/widgets/discovered_list_item.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';
import 'package:provider/provider.dart';

class DiscoverersConnectedList extends StatelessWidget {
  static final logger = Logger();
  const DiscoverersConnectedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const NCAppBar(),
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
              Consumer<DiscovererViewModel>(
                  builder: (context, app, child) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(0),
                      itemCount: app.getDiscoveredDevicesAmount(),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        Item item = app.getDiscoveredDevices()[index].toItem();
                        logger.i("Item in list build $item");
                        return DiscoveredListItem(item, app);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
