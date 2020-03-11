import 'package:app5dm/utils/index.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';


class PreparingView extends StatefulWidget {
  @override
  _PreparingViewState createState() => _PreparingViewState();
}

class _PreparingViewState extends State<PreparingView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;
  Tween<double> _tween = new Tween(begin: 0, end: Screen.setWidth(300) - 10);
  double dx1 = 0;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = _tween.animate(
        CurveTween(curve: Curves.easeInOutQuint).animate(_animationController)
          ..addListener(() {
            setState(() {
              dx1 = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {});
              // _animationController.reverse();
              _animationController.repeat();
            } else if (status == AnimationStatus.dismissed) {
              setState(() {});
              _animationController.forward();
            }
          }));
          _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(80),
      child: Center(
        child: Container(
          height: Screen.setHeight(200),
          width: Screen.setWidth(300),
          // color: Colors.white,
          child: Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(dx1, 0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[300],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-10, 0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[200],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompleteView extends StatelessWidget {
  final IjkMediaController _controller;
  CompleteView(this._controller);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
          icon: Icon(Icons.replay),
          onPressed: () async {
            await _controller?.seekTo(0);
            await _controller?.play();
          }),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('出错了...'),
    );
  }
}

class PauseView extends StatelessWidget {
  final IjkMediaController _controller;
  const PauseView(
    this._controller, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NoDataSourceView extends StatelessWidget {
  final String imgUrl;
  NoDataSourceView(this.imgUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(imgUrl),
          fit: BoxFit.cover
        )
      ),
      child: PreparingView(),
    );
  }
}

class PreparedView extends StatelessWidget {
  final IjkMediaController _controller;
  PreparedView(this._controller);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _controller.play,
      child: Center(
      child:  Icon(Icons.play_arrow, color: Colors.white,),
    ),
    );
  }
}
