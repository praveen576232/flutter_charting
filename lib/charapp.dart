import 'package:charting/chart.dart';
import 'package:charting/status.dart';
import 'package:flutter/material.dart';
class ChartApp extends StatefulWidget {
  @override
  _ChartAppState createState() => _ChartAppState();
}

class _ChartAppState extends State<ChartApp>with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController=TabController(length: 3,vsync: this);
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("WELCOME",textAlign: TextAlign.center,)),
            bottom: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                 text: "CHARTS",
                ),
                Tab(
                 text: "STATUS",  
                ),
                Tab(
                 text: "CALLS",               
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
             Chart(),
             Status(),
             Chart(),
            ],
          ),
        ),
    );
  //  );
  }
}