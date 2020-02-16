import 'package:app5dm/providers/playProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "/playerPage",
  routeName: "playerPage",
  argumentNames: ["link"],
  showStatusBar: false,
)
class PlayerPage extends StatefulWidget {
  final String link;
  PlayerPage({this.link});
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerProvderModel(widget.link),
      child: Scaffold(
          appBar: AppBar(
            title: Selector<PlayerProvderModel, String>(
                builder: (_, viderTitle, child) {
                  return Text('$viderTitle');
                },
                selector: (_, playerModel) => playerModel.viderTitle),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (c, b) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  leading: GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () => Navigator.pop(context),
                  ),
                  title: Text('player'),
                  flexibleSpace: FlexibleSpaceBar(
                      // title: Text('data'),
                      ),
                )
              ];
            },
            body: ViewWidget<PlayerProvderModel>(
              skelelon: PlayerSkeleton(),
              child: Column(
                children: <Widget>[
                  Container(
                    width: Screen.screenWidth,
                    height: Screen.setHeight(500),
                    child: Selector<PlayerProvderModel, String>(
                      builder: (c, viderSrc, child) {
                        controller.setNetworkDataSource(viderSrc,
                            autoPlay: true);
                        return IjkPlayer(
                          mediaController: controller,
                          controllerWidgetBuilder: (mediaController) {
                            return DIJKControllerWidget(
                              controller: mediaController,
                            ); // 自定义
                          },
                        );
                      },
                      selector: (_, playerModel) => playerModel.videoSrc,
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (c, PlayerProvderModel playerModel, _) {
                        var sources = playerModel.sources;
                        return ListView.builder(
                          itemBuilder: (c, index) {
                            var links = sources[0].links[index];
                            return ListTile(
                              title: Text('${links.title}'),
                              onTap: () {
                                playerModel.getData(links.link);
                              },
                            );
                          },
                          itemCount: sources[0].links.length,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class PlayerSkeleton extends StatelessWidget {
  final IjkMediaController controller = IjkMediaController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Screen.setHeight(500),
      child: IjkPlayer(
        mediaController: controller,
        controllerWidgetBuilder: (mediaController) {
          return DIJKControllerWidget(
            controller: mediaController,
          ); // 自定义
        },
      ),
    );
  }
}
