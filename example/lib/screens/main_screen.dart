import 'package:flutter/material.dart';
import 'package:nearby_cross_example/models/app_model.dart';
import 'package:nearby_cross_example/screens/advertising_list.dart';
import 'package:nearby_cross_example/widgets/input_dialog.dart';
import 'package:nearby_cross_example/widgets/nc_appBar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isDiscovering = false;

  void _startDiscovery() async {
    setState(() {
      _isDiscovering = true;
      print('Discovery changed to $_isDiscovering');
    });
  }

  void _stopDiscovery() async {
    setState(() {
      _isDiscovering = false;
      print('Discovery changed to $_isDiscovering');
    });
  }

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
                  Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                        "https://image.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg",
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                      if (value == false)
                        {app.stopDiscovery()}
                      else
                        {app.startDiscovery()}
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
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdvertiserList(),
                    ));
                  },
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
                const ListTile(
                  tileColor: Color(0x1fffffff),
                  title: Text(
                    "Pending Devices",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Color(0xff212435), size: 24),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {},
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
                "Log out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
