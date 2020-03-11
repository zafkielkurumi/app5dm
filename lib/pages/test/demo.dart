import 'package:app5dm/constants/config.dart';
import 'package:app5dm/constants/images.dart';
import 'package:app5dm/providers/testProvider.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:provider/provider.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  ScrollController _sc = ScrollController();

  double pinHeight = playerHeight;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    print('build');
    return ChangeNotifierProvider<TestModel>(
      create: (_) => TestModel(),
      child: Scaffold(
        floatingActionButton: Selector<TestModel, TestModel>(
            builder: (_, model, chidl) {
              return FloatingActionButton(
                onPressed: () {
                  model.changePinHeight();
                    pinHeight = pinHeight == kToolbarHeight  ? playerHeight : kToolbarHeight;
                  // setState(() {});
                },
                child: Text('pinHeight'),
              );
            },
            selector: (_, model) => model),
        body: Selector<TestModel, double>(
          selector: (_, testModel) => testModel.pinHeigt,
            builder: (ctx, pin4Height, child) {
              TestModel _model = Provider.of<TestModel>(ctx, listen: false);
              print('builf');
              print(pinHeight);
              return NestedScrollView(
                controller: _model.sc,
                dragStartBehavior: DragStartBehavior.start,
                headerSliverBuilder: (ctx, b) {
                  return [
                    buildSliverPersistentHeader(),
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
                    Text('data'),
                    Expanded(
                        child: NestedScrollViewInnerScrollPositionKeyWidget(
                            Key('tab1'), TabItem('tab1'))),
                  ],
                ),
              );
            },
            ),
      ),
    );
  }

  SliverPersistentHeader buildSliverPersistentHeader() {
    return SliverPersistentHeader(
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
                          minHeigth: playerHeight));
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ScrollController _sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: List.generate(50, (index) {
        return ListTile(
          title: Text('$index'),
        );
      }),
    );
  }
}
