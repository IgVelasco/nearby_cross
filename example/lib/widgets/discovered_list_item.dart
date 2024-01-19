import 'package:flutter/material.dart';
import 'package:nearby_cross/types/item_type.dart';
import 'package:nearby_cross_example/viewmodels/discoverer_viewmodel.dart';

class DiscoveredListItem extends StatelessWidget {
  final Item item;
  final DiscovererViewModel provider;
  const DiscoveredListItem(this.item, this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      color: const Color(0xffffffff),
      shadowColor: const Color(0x4d939393),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xfff2f2f2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_box_outlined,
                color: Color(0xff212435),
                size: 24,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      item["endpointName"]!,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff000000),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                      child: Text(
                        item["endpointId"]!,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff6c6c6c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff3a57e8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    provider.connect(item["endpointId"]!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Color(0xffffffff),
                    size: 16,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
