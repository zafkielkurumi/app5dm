import 'package:app5dm/constants/config.dart';
import 'package:app5dm/providers/baseProvider.dart';
import 'package:app5dm/providers/playerProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:app5dm/widgets/playerUi/IjkStatusWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './fullController.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlayerModel model = Provider.of<PlayerModel>(context, listen: false);
    return Selector<PlayerModel, bool>(
        selector: (_, playerModel) => playerModel.isShowTitle,
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
        builder: (_, isShowTitle, child) {
          return SliverAppBar(
            pinned: true,
            leading: isShowTitle
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: null,
                  )
                : SizedBox.shrink(),
            expandedHeight: playerHeight,
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
  }
}
