import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
class MediaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          home: Scaffold(
                      body: Container(
      color:Colors.red,
     child: StaggeredGridView.countBuilder(
       crossAxisCount:4 ,
         crossAxisSpacing: 4.0,
       mainAxisSpacing: 4.0,
        itemBuilder: (context,i){
          return Container(
            color: Colors.green,
            child: Text(i.toString())
          )
          ;
        }, staggeredTileBuilder: (i){
          return StaggeredTile.count(2, 2);
        }),
      ),
          ),
    );
  }
}