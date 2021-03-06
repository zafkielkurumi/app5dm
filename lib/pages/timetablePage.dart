import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:app5dm/providers/timeLineProvider.dart';
import 'package:provider/provider.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  intTabController(int lenth) {
    int week = DateTime.now().weekday;
    _tabController = _tabController == null
        ? TabController(
            length: lenth, vsync: this, initialIndex: week == 7 ? 0 : week)
        : _tabController;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ChangeNotifierProvider<TimelineModel>(
        create: (_) => TimelineModel(),
        child: ViewWidget<TimelineModel>(
          skelelon: SkeletonList(
            listTitle: TimeTableSkeleton(),
          ),
          child: Selector<TimelineModel, List<VideoItems>>(
            selector: (_, timelineModel) => timelineModel.timelines,
            builder: (ctx, timelines, child) {
              intTabController(timelines.length);

              // var pinnedHeaderHeight = kTextTabBarHeight + Screen.statusHeight;
              var pinnedHeaderHeight = kTextTabBarHeight;
              
              return Theme(
                data: Theme.of(context)
                    .copyWith(splashFactory: NoSplashFactory()),
                child: NestedScrollViewRefreshIndicator(
                  onRefresh: Provider.of<TimelineModel>(ctx, listen: false).refresh,
                  child: NestedScrollView(
                    headerSliverBuilder: (c, b) {
                      return [
                        SliverAppBar(
                          pinned: false,
                          floating: true,
                          snap: false,
                          elevation: 0, //
                          title: Text('时间表'),
                        ),
                        TabAppBar(tabController: _tabController, timelines: timelines),
                      ];
                    },
                    pinnedHeaderSliverHeightBuilder: () {
                      return pinnedHeaderHeight;
                    },
                    innerScrollPositionKeyBuilder: () {
                      return Key('tab${_tabController.index}');
                    },
                    body:  TabBarView(
                          controller: _tabController,
                          children: List.generate(timelines.length, (index) {
                            var timeline = timelines[index];

                            return NestedScrollViewInnerScrollPositionKeyWidget(
                                Key('tab$index'), TimeLineList(timeline));
                          }),
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TabAppBar extends StatelessWidget {
  const TabAppBar({
    Key key,
    @required TabController tabController,
    @required this.timelines,
  }) : _tabController = tabController, super(key: key);

  final TabController _tabController;
  final List<VideoItems> timelines;

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      title: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: _theme.primaryColor,
        unselectedLabelColor: _theme.primaryTextTheme.display1.color,
        indicator: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _theme.primaryTextTheme.display1.color,
              spreadRadius: 3
            )
          ],
          shape: BoxShape.circle,
        ),
        tabs: timelines.map((item) {
          return Tab(
            child: SizedBox(
              child: Center(
                child: Text(
                  '${item.title.substring(1)}',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TimeLineList extends StatefulWidget {
  final VideoItems timeline;
  TimeLineList(this.timeline);
  @override
  _TimeLineListState createState() => _TimeLineListState();
}

class _TimeLineListState extends State<TimeLineList>
    with AutomaticKeepAliveClientMixin {
  get timeline => widget.timeline;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.builder(
        itemBuilder: (c, index) {
          Seasons season = timeline.seasons[index];
          return InkWell(
            child: SeasonTitle(
              season: season,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.PLAYERPAGE,
                  arguments: {"link": season.stringId});
            },
          );
        },
        itemCount: timeline.seasons.length,
      ),
    );
  }
}

class SeasonTitle extends StatelessWidget {
  final Seasons season;
  SeasonTitle({this.season});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            height: Screen.setWidth(tranferImageWidthToHeiht(200)),
            width: Screen.setWidth(200),
            decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ImageView(url: season.imgUrl),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            '${season.title}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
    );
  }
}
