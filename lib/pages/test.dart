import 'package:app5dm/app5dm_route.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: AppBar(title: Text('home')),
      body: Column(
        children: <Widget>[
          // RaisedButton(onPressed: () {
          //   Navigator.of(context).pushNamed(Routes.PLAYERPAGE, arguments: {"link": '2'});
          // },child: Text('player'),),
          Expanded(child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                title: Text('data1'),
              ),
              SliverAppBar(
                pinned: true,
                title: Text('data'),
              ),
              SliverList(delegate: SliverChildListDelegate(
                List.generate(50, (index){
                  return Text('data');
                })
              ),)
            ],
          ),)
        ],
      ),
    );
  }
}
