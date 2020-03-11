import 'package:app5dm/constants/config.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/playerUi/IjkStatusWidgets.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

import 'brief.dart';
import 'fullController.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  SliverPersistentHeader buildPlayerHeader(PlayerModel model) {
    return SliverPersistentHeader(
    floating: true,
    delegate: CustomSliverPersistentHeader(
        child: Selector<PlayerModel, ViewState>(
          selector: (_, playerModel) => playerModel.viewState,
          child: Player(
            controller: model.playerController,
            noSourcePic: model.noSourcePic,
            fullControllerWidget: (tip, mediaController) {
              return FullController(
                controller: mediaController,
                info: mediaController.videoInfo,
                tipHelper: tip,
                playerModel: model,
              );
            },
          ),
          builder: (_, viewState, player) {
            return Stack(
              children: <Widget>[
                player,
                viewState == ViewState.pending
                    ? PreparingView()
                    : SizedBox.shrink()
              ],
            );
          },
        ),
        minHeigth: playerHeight),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) =>
            PlayerModel(link: widget.link, noSourcePic: widget.picUrl),
        child: Selector<PlayerModel, PlayerModel>(
          selector: (_, playerModel) => playerModel,
          child: PlayerHeader(),
          builder: (ctx, playerModel, child) {
            PlayerModel _model = Provider.of<PlayerModel>(ctx, listen: false);
            print('build');
            return NestedScrollView(
              controller: _model.scrollController,
              headerSliverBuilder: (c, b) {
                return [buildPlayerHeader(_model)];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return playerModel.pinHeight;
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
            );
          },
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
