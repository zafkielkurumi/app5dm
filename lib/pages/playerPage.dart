import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => PlayerModel(link: widget.link, noSourcePic: widget.picUrl),
        child: Selector<PlayerModel, PlayerModel>(
          selector: (_, model) => model,
          child: PlayerHeader(),
          builder: (_, model, child) {
            return NestedScrollView(
                  controller: model.scrollController,
                  headerSliverBuilder: (c, b) {
                    return [
                      // TODO pinnedHeaderSliverHeightBuilder rebuild不会执行问题，待解决
                      child
                      // SliverPersistentHeader(
                      //   delegate: CustomSliverPersistentHeader(
                      //       minHeigth: pinHeight,
                      //       maxHeight: Screen.setHeight(450),
                      //       child: Container(
                      //         color: Colors.red,
                      //       )),
                      // )
                    ];
                  },
                  pinnedHeaderSliverHeightBuilder: () {
                    return kToolbarHeight;
                  },
                  body: ViewWidget<PlayerModel>(
                    child: Column(
                      children: <Widget>[
                        RaisedButton(onPressed: model.changePausePinHeight, child: Text('chang56'),),
                        RaisedButton(onPressed: model.changePlayPinHeight, child: Text('chang246'),),
                        Expanded(
                          child: Selector<PlayerModel, PlayerModel>(
                              selector: (_, playerModel) => playerModel,
                              builder: (_, playerModel, child) {
                                return ListView.builder(
                                  itemBuilder: (c, index) {
                                    var links =
                                        playerModel.sources[0].links[index];
                                    return ListTile(
                                      title: Text('${links.title}'),
                                      onTap: () {
                                        playerModel.getData(links.link);
                                      },
                                    );
                                  },
                                  itemCount:
                                      playerModel.sources[0].links.length,
                                );
                              }),
                        )
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

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PlayerModel, PlayerModel>(
      shouldRebuild: (prev, next) => false, // 虽然选择对象不会rebuild，保险起见
        builder: (_, model, child) {
          return Selector<PlayerModel, bool>(
              selector: (_, playerModel) => playerModel.isShowTitle,
              child: Container(
                height: Screen.setHeight(450),
                child: Player(
                  controller: model.controller,
                  noSourcePic: model.noSourcePic,
                ),
              ),
              builder: (_, isShowTitle, child) {
                return SliverAppBar(
                  pinned: true,
                  leading: isShowTitle
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: model.changePlayPinHeight,
                        )
                      : SizedBox.shrink(),
                  expandedHeight: Screen.setHeight(450),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(bottom: 0),
                    centerTitle: true,
                    background: child,
                    collapseMode: CollapseMode.pin,
                    title: isShowTitle
                        ? Center(
                            child: GestureDetector(
                            onTap: model.changePausePinHeight(),
                            child: Text('立即播放2'),
                          ))
                        : SizedBox.shrink(),
                  ),
                );
              });
        },
        selector: (_, playerModel) => playerModel);
  }
}
