import 'package:flutter/material.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:nearby_cross_example/widgets/advertising_list_item.dart';
import 'package:nearby_cross_example/widgets/nc_appBar.dart';
import 'package:provider/provider.dart';

class AdvertiserList extends StatelessWidget {
  const AdvertiserList({super.key});

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
              Consumer<AppModel>(
                  builder: (context, app, child) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(0),
                      itemCount: app.totalAmount,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        Item item = app.items[index];
                        print(item);
                        String username =
                            item["username"] ?? "Default username";
                        String endpointId = item["endpointId"] ?? "ABCX";
                        return AdvertisingListItem(username, endpointId);
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
