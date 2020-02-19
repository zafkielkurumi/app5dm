import 'dart:async';
import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/models/index.dart';
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
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider<HomeModel>(
        create: (_) => HomeModel(),
        child: ViewWidget<HomeModel>(
          skelelon: Loading(),
          child: Selector<HomeModel, List<VideoItems>>(
            selector: (_, homeModel) => homeModel.homelines,
            builder: (_, homelines, child) {
              return Theme(data: Theme.of(context).copyWith(
                splashFactory: NoSplashFactory()
              ), child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    leading:
                        IconButton(icon: Icon(Icons.menu), onPressed: null),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.SEARCHPAGE);
                      },
                      child: Container(
                      height: Screen.setHeight(40),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    ),
                  ),
                  ...List.generate(homelines.length, (index) {
                    var videoItem = homelines[index];
                    if (index == 0) {
                      return SliverPadding(padding: EdgeInsets.only(left: 10, right: 10, top: 10), sliver: SliverToBoxAdapter(
                        child: HomeSlider(
                          seasons: videoItem.seasons,
                          width: Screen.width - 20,
                          height: tranferImageWidthToHeiht(Screen.width - 20),
                        ),
                      ),);
                    } else {
                      return SliverToBoxAdapter(
                        child: Padding(padding: EdgeInsets.only(left:10,right:10), child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('${videoItem.title}'),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      children: <Widget>[
                                        Text('查看更多'),
                                        Icon(Icons.keyboard_arrow_right)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Wrap(
                                spacing: Screen.setWidth(20),
                                runSpacing: Screen.setWidth(10),
                                children: List.generate(
                                    videoItem.seasons.length, (index) {
                                  var season = videoItem.seasons[index];
                                  var itemWidth = (Screen.width -
                                          20 -
                                          Screen.setWidth(20)) /
                                      2;
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.PLAYERPAGE,
                                        arguments: {"link": season.stringId},
                                      );
                                    },
                                    child: Container(
                                      width: itemWidth,
                                      child: VideoItemIntroduce(
                                        imgUrl: season.imgUrl,
                                        title: season.title,
                                        width: itemWidth,
                                      ),
                                    ),
                                  );
                                }))
                          ],
                        ),),
                      );
                    }
                  }),
                ],
              ),);
            },
          ),
        ),
      ),
    );
  }
}

class HomeSlider extends StatefulWidget {
  final List<Seasons> seasons;
  final double height;
  final double width;
  HomeSlider({@required this.seasons, this.height: 300, this.width});
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  List<Seasons> get seasons => widget.seasons;
  Timer _timer;
  @override
  void initState() {
    // Future.microtask(() {});
    _pageController.addListener(() {
      print('object');
    });
    super.initState();
  }

  startTimer() {
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _pageController.nextPage(duration: null, curve: null);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          print(index);
        },
        children: List.generate(seasons.length, (index) {
          var season = seasons[index];
          return SliderItem(season);
        }),
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: Screen.setWidth(500),
                child: Text(
                  '${_season.title}',
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              Text('右')
            ],
          ),
        )
      ],
    );
  }
}
