import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/models/timelime_model.dart';
import 'package:app5dm/providers/homeProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('todo search')),
      body: ChangeNotifierProvider<HomeModel>(
        create: (_) => HomeModel(),
        child: ViewWidget<HomeModel>(
          skelelon: Loading(),
          child: Selector<HomeModel, List<Timeline>>(
            selector: (_, homeModel) => homeModel.homelines,
            builder: (_, homelines, child) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    child: HomeSlider(homelines.first.seasons),
                  ),
                  Expanded(child: Container())
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeSlider extends StatefulWidget {
  final List<Seasons> seasons;
  HomeSlider(this.seasons);
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController _pageController = PageController();
   List<Seasons> get seasons => widget.seasons;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: List.generate(seasons.length, (index) {
        var season = seasons[index];
        return SliderItem(season);
      }),
    );
  }
}

class SliderItem extends StatelessWidget {
  final Seasons _season;
  SliderItem(this._season);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ImageView(url: _season.imgUrl),
        Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: Screen.setWidth(100),
                  child: Text('${_season.title}', overflow: TextOverflow.ellipsis, softWrap: false,),
                ),
                Expanded(child: Text('右'))
              ],
            ),
          )
      ],
    );
  }
}
