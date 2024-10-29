import 'package:flutter/material.dart';
import 'Sample1.dart';
import 'Sample2.dart';

class Echart_page extends StatelessWidget {
  const Echart_page({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Sample 1',
                ),
                Tab(
                  text: 'Sample 2',
                ),
              ],
            ),
          ),
          body: const TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            Center(child: Sample1()),
            Center(
              child: Sample2(),
            ),
          ]),
        ));
  }
}
