import 'package:app5dm/constants/config.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

class TestRoutePage extends StatefulWidget {
  @override
  _TestRoutePageState createState() => _TestRoutePageState();
}

class _TestRoutePageState extends State<TestRoutePage>
    with TickerProviderStateMixin {
  ScrollController _sc = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  double pinHeight = playerHeight;
  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
          pinHeight = pinHeight == kToolbarHeight  ? playerHeight : kToolbarHeight;
          isPlay = !isPlay;
                  // _sc.position.applyContentDimensions(
                  //     _sc.position.minScrollExtent,
                  //     _sc.position.maxScrollExtent + pinHeight);
                      setState(() {
                        
                      });
      }, child: Text('$pinHeight'),),
      body: NestedScrollView(
          controller: _sc,
          dragStartBehavior:DragStartBehavior.start,
          headerSliverBuilder: (ctx, b) {
            return [
              SliverPersistentHeader(
                  floating: true,
                  delegate: CustomSliverPersistentHeader(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              print('tap');
                            },
                            child: Container(
                            height: playerHeight,
                            color: Colors.red,
                          ),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: Container(
                              height: 50,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                      minHeigth: playerHeight)),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return pinHeight;
          },
          innerScrollPositionKeyBuilder: () {
            return Key('tab1');
          },
          body: Column(
            
            children: <Widget>[
              Expanded(child: NestedScrollViewInnerScrollPositionKeyWidget(
                      Key('tab1'), TabItem('tab1'))),
            ],
          ),),
    );
  }
}

class TabItem extends StatefulWidget {
  final String name;
  TabItem(this.name);
  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: List.generate(50, (index) {
        return ListTile(title: Text('$index'),);
      }),
    );
  }
}
