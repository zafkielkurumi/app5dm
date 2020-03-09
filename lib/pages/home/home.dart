import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/pages/home/drawer.dart';
import 'package:app5dm/providers/homeProvider.dart';
import 'package:app5dm/providers/themeProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
    return SafeArea(
        child: Scaffold(
      drawer: Drawer(
        child: HomeDrawer(),
      ),
      body: ChangeNotifierProvider<HomeModel>(
        create: (_) => HomeModel(),
        child: ViewWidget<HomeModel>(
          skelelon: SkeletonGirdList(),
          child: Selector<HomeModel, List<VideoItems>>(
            selector: (_, homeModel) => homeModel.homelines,
            child: HomeAppBar(),
            builder: (ctx, homelines, child) {
              return Theme(
                  data: Theme.of(context)
                      .copyWith(splashFactory: NoSplashFactory()),
                  child: RefreshIndicator(
                    onRefresh:
                        Provider.of<HomeModel>(ctx, listen: false).refresh,
                    child: CustomScrollView(
                      slivers: [
                        child,
                        ...List.generate(homelines.length, (index) {
                          var videoItem = homelines[index];
                          if (index == 0) {
                            return HomeSwiper(videoItem: videoItem);
                          } else {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    MoreTitle(videoItem: videoItem),
                                    SeasonItems(videoItem: videoItem)
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    ));
  }
}

class MoreTitle extends StatelessWidget {
  const MoreTitle({
    Key key,
    @required this.videoItem,
  }) : super(key: key);

  final VideoItems videoItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${videoItem.title}'),
          videoItem.more.isEmpty
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.SERIALPAGE,
                        arguments: {
                          "link": videoItem.more,
                          "title": videoItem.title
                        });
                  },
                  child: Row(
                    children: <Widget>[
                      Text('查看更多'),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class SeasonItems extends StatelessWidget {
  const SeasonItems({
    Key key,
    @required this.videoItem,
  }) : super(key: key);

  final VideoItems videoItem;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: Screen.setWidth(20),
        runSpacing: Screen.setWidth(10),
        children: List.generate(videoItem.seasons.length, (index) {
          var season = videoItem.seasons[index];
          var itemWidth = (Screen.width - 20 - Screen.setWidth(20)) / 2;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.PLAYERPAGE,
                arguments: {"link": season.stringId, "picUrl": season.imgUrl},
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
        }));
  }
}

class HomeSwiper extends StatelessWidget {
  const HomeSwiper({
    Key key,
    @required this.videoItem,
  }) : super(key: key);

  final VideoItems videoItem;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          width: Screen.width - 20,
          height: tranferImageWidthToHeiht(Screen.width - 20),
          child: Swiper(
            onTap: (index) {
              var season = videoItem.seasons[index];
              Navigator.of(context).pushNamed(Routes.PLAYERPAGE,
                  arguments: {"link": season.stringId});
            },
            itemCount: videoItem.seasons.length,
            pagination: SwiperPagination(),
            itemBuilder: (_, index) {
              var season = videoItem.seasons[index];
              return SliderItem(season);
            },
          ),
        ),
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Provider.of<CustomThemeModel>(context, listen: false)
                .switchRandomTheme();
          }),
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
          child: Container(
            width: Screen.setWidth(500),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(150, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0),
                ])),
            child: Text(
              '${_season.title}',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        )
      ],
    );
  }
}
