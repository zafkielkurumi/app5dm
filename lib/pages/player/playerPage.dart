import 'dart:async';

import 'package:app5dm/constants/config.dart';
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
  bool _isPlaying = true;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    initListener();
    super.initState();
  }

  initListener() {
    _videoSteam = playController.videoInfoStream.listen((info) {
      if (info != null && _isPlaying != info.isPlaying && mounted) {
         _isPlaying = info.isPlaying;
          pinHeight = _isPlaying ? playerHeight : kToolbarHeight;
          setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoSteam?.cancel();
    _tabController.dispose();
    playController.dispose();
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
            scrollController: _sc,
            playController: playController),
        child: NestedScrollView(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.grey[200]),
                    ),
                  ),
                  child: PlayerTabBar(tabController: _tabController),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('tab0'),
                        Brief(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      width: Screen.setWidth(200),
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
        ],
      ),
    );
  }
}
