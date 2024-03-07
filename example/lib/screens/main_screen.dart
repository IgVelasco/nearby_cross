import 'package:flutter/material.dart';
import 'package:nearby_cross/constants/nearby_strategies.dart';
import 'package:nearby_cross_example/viewmodels/main_viewmodel.dart';
import 'package:nearby_cross_example/widgets/discoverer_actions.dart';
import 'package:nearby_cross_example/widgets/input_dialog.dart';
import 'package:nearby_cross_example/widgets/nc_app_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/advertiser_actions.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => MainViewModel())],
      builder: (context, child) {
        var vm = Provider.of<MainViewModel>(context, listen: false);

        return Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: NCAppBar(),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        color: Colors.white,
                                        shape: CircleBorder(),
                                      ),
                                      child: Consumer<MainViewModel>(
                                        builder: (context, viewModel, child) =>
                                            IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: viewModel.advertiserMode
                                              ? Colors.blue
                                              : Colors.red,
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) {
                                              return InputDialog(vm.username,
                                                  (input) {
                                                vm.setUsername(input);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Consumer<MainViewModel>(
                                      builder: (context, viewModel, child) =>
                                          Text(
                                        viewModel.username,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18,
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                        Expanded(
                            child: Column(children: [
                          Consumer<MainViewModel>(
                            builder: (context, viewModel, child) =>
                                SwitchListTile(
                                    value: viewModel.advertiserMode,
                                    activeColor: Colors.blue,
                                    inactiveTrackColor: Colors.red,
                                    onChanged: (value) =>
                                        viewModel.toggleAdvertiserMode()),
                          ),
                          MaterialButton(
                            onPressed: () {},
                            color: const Color.fromARGB(255, 92, 95, 112),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            textColor: const Color(0xffffffff),
                            child: Consumer<MainViewModel>(
                              builder: (context, viewModel, child) => Text(
                                viewModel.mode,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          )
                        ]))
                      ],
                    ),
                  ),
                  Consumer<MainViewModel>(
                      builder: (context, viewModel, child) => ListView(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: [
                              ListTile(
                                title: const Text("Strategy"),
                                trailing: DropdownButton<NearbyStrategies>(
                                  value: viewModel.strategy,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: viewModel.advertiserMode
                                          ? Colors.blue
                                          : Colors.red),
                                  underline: Container(
                                    height: 2,
                                    color: viewModel.advertiserMode
                                        ? Colors.blue
                                        : Colors.red,
                                  ),
                                  onChanged: (NearbyStrategies? value) {
                                    viewModel.setStrategy(value!);
                                  },
                                  items: NearbyStrategies.values
                                      .map<DropdownMenuItem<NearbyStrategies>>(
                                          (NearbyStrategies value) {
                                    return DropdownMenuItem<NearbyStrategies>(
                                      value: value,
                                      child: Text(value.toPresentationString()),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          )),
                  Consumer<MainViewModel>(
                    builder: (context, viewModel, child) =>
                        viewModel.advertiserMode
                            ? Consumer<MainViewModel>(
                                builder: (context, viewModel, child) =>
                                    AdvertiserActions(
                                        viewModel.username, viewModel.strategy),
                              )
                            : Consumer<MainViewModel>(
                                builder: (context, viewModel, child) =>
                                    DiscovererActions(
                                        viewModel.username, viewModel.strategy),
                              ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
