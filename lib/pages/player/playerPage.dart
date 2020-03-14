import 'dart:async';
import 'dart:io';

import 'package:app5dm/constants/config.dart';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/pages/player/comment.dart';
import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:provider/provider.dart';

import 'brief.dart';
import 'playerHeader.dart';

@FFRoute(
  name: "/playerPage",
  routeName: "playerPage",
  argumentNames: ["link", 'picUrl'],
)
class PlayerPage extends StatefulWidget {
  final String link;
  final String picUrl;
  PlayerPage({this.link, this.picUrl});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _sc = ScrollController();
  double pinHeight = playerHeight;
  IjkMediaController playController = IjkMediaController();
  StreamSubscription _videoSteam;
  bool _isShowTitle = false;
  bool _isPlaying = true;
  double _opacity = 0;
  double _maxHeight = playerHeight;
  double scOffset = 0;
  double isShowHeight = 95;
  bool testShow = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    initListener();
    super.initState();
  }

  initListener() {
    _sc.addListener(offsetListener);
    _videoSteam = playController.videoInfoStream.listen((info) {
      if (info.hasData && _isPlaying != info.isPlaying && mounted) {
        _isPlaying = info.isPlaying;
        pinHeight = _isPlaying ? playerHeight : kToolbarHeight;
        setState(() {});
      }
    });
  }

  offsetListener() {
    if ((_maxHeight - _sc.offset) < isShowHeight && !_isShowTitle) {
      _isShowTitle = true;
      _opacity = 1;
      setState(() {});
    } else if ((_maxHeight - _sc.offset) > isShowHeight && _isShowTitle) {
      _opacity = 0;
      _isShowTitle = false;
      setState(() {});
    }
    setState(() {
      scOffset = _sc.offset;
    });
  }

  @override
  void dispose() {
    _videoSteam?.cancel();
    _tabController.dispose();
    playController.dispose();
    _sc.removeListener(offsetListener);
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: ChangeNotifierProvider(
            create: (_) => PlayerModel(
                link: widget.link,
                noSourcePic: widget.picUrl,
                playController: playController),
            child: Stack(
              children: <Widget>[
                NestedScrollView(
                  controller: _sc,
                  headerSliverBuilder: (c, b) {
                    return [
                      PlayerHeader(
                        playController: playController,
                      )
                    ];
                  },
                  pinnedHeaderSliverHeightBuilder: () {
                    return pinHeight;
                  },
                  innerScrollPositionKeyBuilder: () =>
                      Key('tab${_tabController.index}'),
                  body: ViewWidget<PlayerModel>(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey[200]),
                                ),
                              ),
                              child:
                                  PlayerTabBar(tabController: _tabController),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Brief(),
                                  Comment(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        LinksSheet(),
                      ],
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _opacity,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: _maxHeight - scOffset,
                    ),
                  ),
                ),
                if (_isShowTitle) PlayerTitle(playController: playController)
              ],
            ),
          ),
        );
  }
}

class LinksSheet extends StatelessWidget {
  const LinksSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerModel _model = Provider.of<PlayerModel>(context, listen: false);
    return WillPopScope(child: Selector<PlayerModel, bool>(
      selector: (_, playerModel) => playerModel.isShowSheet,
      builder: (_, isShowSheet, child) => AnimatedPositioned(
        top: isShowSheet ?  0 : Screen.height -kToolbarHeight ,
        left: 0,
        bottom: 0,
        right: 0,
        duration: Duration(milliseconds: 300),
        child: child,
      ),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Selector<PlayerModel, List<Links>>(
              builder: (_, links, child) {
                return Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  spacing: 15,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('共${links.length}话'),
                        IconButton(icon: Icon(Icons.close), onPressed: () {
                          _model.showModelSheet();
                        })
                      ],
                    ),
                    ...List.generate(links.length, (index) {
                      Links link = links[index];
                      return Selector<PlayerModel, String>(
                          builder: (_, url, c) {
                            return OutlineButton(
                              borderSide: BorderSide(
                                  color: url == link.url
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[400]),
                              onPressed: () {
                                _model.changeLink(link.url);
                                _model.showModelSheet();
                              },
                              child: Text('第${index + 1}话'),
                            );
                          },
                          selector: (_, playerModel) => playerModel.link);
                    })
                  ],
                );
              },
              selector: (_, playerModel) => playerModel.links),
        ),
      ),
    ), onWillPop: () async {
      if (_model.isShowSheet) {
        _model.showModelSheet();
        return false;
      } else {
        return true;
      }
    });
  }
}

class PlayerTitle extends StatelessWidget {
  const PlayerTitle({
    Key key,
    @required this.playController,
  }) : super(key: key);

  final IjkMediaController playController;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: kToolbarHeight,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  playController.play();
                },
                child: Center(
                  child: Text(
                    '立即播放',
                    style: TextStyle(
                        color: Colors.white, fontSize: Screen.setSp(40)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              width: 48,
            ),
          ],
        ));
  }
}

class PlayerTabBar extends StatelessWidget {
  const PlayerTabBar({
    Key key,
    @required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: TabBar(
        labelColor: Theme.of(context).primaryColor,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.black54,
        controller: _tabController,
        tabs: [
          Tab(
            text: '简介',
          ),
          Tab(
            text: '评论',
          ),
        ],
      ),
    );
  }
}
