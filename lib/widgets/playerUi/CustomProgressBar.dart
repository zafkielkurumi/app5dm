import 'package:app5dm/constants/images.dart';
import 'package:flutter/material.dart';

typedef ChangeProgressHandler(double progress);

typedef TapProgressHandler(double progress);

class CustomProgressBar extends StatefulWidget {
  final double max;
  final double current;
  final double buffered; //buffer 暂无
  final Color backgroundColor;
  final Color bufferColor;
  final Color playedColor;
  final ChangeProgressHandler changeProgressHandler;
  final TapProgressHandler tapProgressHandler;

  CustomProgressBar({
    Key key,
    @required this.max,
    @required this.current,
    this.buffered,
    this.backgroundColor = const Color(0xFF616161),
    this.bufferColor = Colors.grey,
    this.playedColor = Colors.white,
    this.changeProgressHandler,
    this.tapProgressHandler,
  }) : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  GlobalKey _progressKey = GlobalKey();
  double tempLeft; // 拖动playbar显示修改

  /// 已经播放占据的flex
  double get left {
    var l = widget.current / widget.max;
    if (tempLeft != null) {
      return tempLeft;
    }
    return l;
  }

  buildColorWidget(Color color, double flex) {
    if (flex == double.infinity ||
        flex == double.nan ||
        flex == double.negativeInfinity) {
      flex = 0;
    }
    if (flex == 0) {
      return Container();
    }
    return Expanded(
      child: Container(
        color: color,
      ),
      flex: (flex * 1000).toInt(),
    );
  }

  double getProgress(Offset localPositon) {
    // var
    RenderBox renderBox = _progressKey.currentContext?.findRenderObject();
    var size = renderBox.size;
    var progress = localPositon.dx / size.width;
    if (progress > 1) {
      progress = 1;
    } else if (progress < 0) {
      progress = 0;
    }
    return progress;
  }

  void _onTapDown(TapDownDetails details) {
    print(details.localPosition);
    print(details.globalPosition);
    var progress = getProgress(details.localPosition);
    // widget.tapProgressHandler(progress);
    // todo showtip
  }

  void _onTapUp(TapUpDetails details) {
    var progress = getProgress(details.localPosition);
    widget.changeProgressHandler(progress);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    var progress = getProgress(details.localPosition);
    setState(() {
      tempLeft = progress;
    });
    widget.tapProgressHandler(progress);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (tempLeft != null) {
      widget.changeProgressHandler(tempLeft);
      tempLeft = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.max == null || widget.current == null || widget.max == 0) {
      return Container();
    }

    var mid = (widget.buffered ?? 0) / widget.max - left;
    if (mid < 0) {
      mid = 0;
    }
    var right = 1 - left - mid;
    var progress = buildProgress(left, mid, right);
    return GestureDetector(
      child: progress,
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
    );
    // return progress;
  }

  Column buildProgress(double left, double mid, double right) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 3,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            key: _progressKey,
            children: <Widget>[
              buildColorWidget(widget.playedColor, left),
              Container(
                width: 0.1,
                height: 0.1,
                child: OverflowBox(
                  maxWidth: 20,
                  maxHeight: 20,
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 10,
                    height: 10,
                    child: Image.asset(Images.logo),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                  ),
                ),
              ),
              buildColorWidget(widget.bufferColor, mid),
              buildColorWidget(widget.backgroundColor, right),
            ],
          ),
        )
      ],
    );
  }
}
