import 'package:flutter/material.dart';
import 'package:nearby_cross/models/device_model.dart';
import 'package:nearby_cross_example/viewmodels/comunication_viewmodel.dart';

import 'package:provider/provider.dart';
import '../widgets/nc_app_bar.dart';

class ComunicationMessage extends StatelessWidget {
  final String text;
  const ComunicationMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1 * 0.7),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              text,
            ),
          ),
        ));
  }
}

class ComunicationScreen extends StatelessWidget {
  final Device device;
  const ComunicationScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ComunicationViewModel(device))
        ],
        child: Scaffold(
          appBar: NCAppBar(
            title: device.endpointName,
          ),
          body: Consumer<ComunicationViewModel>(
              builder: (context, viewModel, child) => LayoutBuilder(
                    builder: (context, constraints) {
                      var vm = Provider.of<ComunicationViewModel>(context,
                          listen: false);

                      return Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Last messages",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 24,
                                          color: Color(0xff272727),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Consumer<ComunicationViewModel>(
                                      builder: (context, provider, child) =>
                                          ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              padding: const EdgeInsets.all(0),
                                              itemCount:
                                                  provider.getMessagesCount(),
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return ComunicationMessage(
                                                    text: provider
                                                            .getLastMessages()[
                                                        index]);
                                              }),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.10,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Send'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        vm.clearMessages();
                                      },
                                      child: const Text('Clear'),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
        ));
  }
}
