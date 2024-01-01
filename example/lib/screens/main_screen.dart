import 'package:flutter/material.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:nearby_cross_example/screens/advertiser_comunication_screen.dart';
import 'package:nearby_cross_example/screens/advertising_list.dart';
import 'package:nearby_cross_example/widgets/input_dialog.dart';
import 'package:nearby_cross_example/widgets/nc_appBar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: const NCAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Consumer<AppModel>(builder: (context, app, child) {
                            return Text(
                              app.username,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                color: Color(0xff000000),
                              ),
                            );
                          }),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: Text(
                                "Username",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff9e9e9e),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: const Color(0xff3a57e8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    textColor: const Color(0xffffffff),
                    child: const Text(
                      "Discoverer",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Consumer<AppModel>(
                  builder: (context, app, child) => MaterialButton(
                        color: const Color(0x343a57e8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: const Color(0xff3a57e8),
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Change Username",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => InputDialog(app.username),
                        ),
                      )),
            ),
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
                    onChanged: (value) => {
                      value == false
                          ? app.stopDiscovery()
                          : app.startDiscovery()
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
                                  color: const Color(0xff212435), size: 24),
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
                              "Connected: Username ${app.connectedAdvertiser["username"]}",
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AdvertiserComunicationScreen(
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
                          Provider.of<AppModel>(context, listen: false)
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
          ],
        ),
      ),
    );
  }
}
