import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerModel(widget.link),
      child: Scaffold(
        appBar: AppBar(
          title: Selector<PlayerModel, String>(
              builder: (_, videoTitle, child) {
                return Text('$videoTitle');
              },
              selector: (_, playerModel) => playerModel.videoTitle),
        ),
        body: ViewWidget<PlayerModel>(
          skelelon: PlayerSkeleton(),
          child: Column(
            children: <Widget>[
              Selector<PlayerModel, IjkMediaController>(
                  builder: (_, controller, child) {
                    return Container(
                      width: Screen.screenWidth,
                      height: Screen.setHeight(500),
                      child: IjkPlayer(
                        mediaController: controller,
                        // controllerWidgetBuilder: (mediaController) {
                        //   return DIJKControllerWidget(
                        //     controller: mediaController,
                        //   ); // 自定义
                        // },
                      ),
                    );
                  },
                  selector: (_, playerModel) => playerModel.controller),
              Expanded(
                child: Selector<PlayerModel, PlayerModel>(
                    selector: (_, playerModel) => playerModel,
                    shouldRebuild: (oldModel, newModel) =>
                        oldModel.sources != newModel.sources,
                    builder: (_, playerModel, child) {
                      return ListView.builder(
                        itemBuilder: (c, index) {
                          var links = playerModel.sources[0].links[index];
                          return ListTile(
                            title: Text('${links.title}'),
                            onTap: () {
                              playerModel.getData(links.link);
                            },
                          );
                        },
                        itemCount: playerModel.sources[0].links.length,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
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
