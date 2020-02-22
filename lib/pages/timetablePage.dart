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
          child: Selector<TimelineModel, TimelineModel>(
            selector: (_, timelineModel) => timelineModel,
            shouldRebuild: (oldModel, newModel) =>
                oldModel.timelines != newModel.timelines,
            builder: (_, TimelineModel timelineModel, child) {
              List<VideoItems> timelines = timelineModel.timelines;
              intTabController(timelines.length);

              var pinnedHeaderHeight = kTextTabBarHeight + Screen.statusHeight;
              return Theme(
                data: Theme.of(context)
                    .copyWith(splashFactory: NoSplashFactory()),
                child: NestedScrollViewRefreshIndicator(
                  onRefresh: timelineModel.refresh,
                  child: NestedScrollView(
                    headerSliverBuilder: (c, b) {
                      return [
                        SliverAppBar(
                          pinned: false,
                          floating: true,
                          snap: false,
                          elevation: 0, //
                          title: Text('时间表'),
                          // flexibleSpace: FlexibleSpaceBar(),
                        ),
                        SliverAppBar(
                          pinned: true,
                          floating: false,
                          snap: false,
                          title: TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Theme.of(context).primaryTextTheme.display1.color,
                            indicator: BoxDecoration(
                              // color: ,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryTextTheme.display1.color,
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
                        ),
                      ];
                    },
                    pinnedHeaderSliverHeightBuilder: () {
                      return pinnedHeaderHeight;
                    },
                    innerScrollPositionKeyBuilder: () {
                      return Key('tab${_tabController.index}');
                    },
                    body: Column(
                      children: <Widget>[
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          children: List.generate(timelines.length, (index) {
                            var timeline = timelines[index];

                            return NestedScrollViewInnerScrollPositionKeyWidget(
                                Key('tab$index'), TimeLineList(timeline));
                            // 这种无法在header reset时候body保持位置
                            // return NestedScrollViewInnerScrollPositionKeyWidget(
                            //   Key('tab$index'),
                            //   ListView.builder(
                            //     key: PageStorageKey('tab$index'),
                            //     itemBuilder: (c, index) {
                            //       Seasons season = timeline.seasons[index];
                            //       return InkWell(
                            //         child: SeasonTitle(
                            //           season: season,
                            //         ),
                            //         onTap: () {
                            //           Navigator.of(context).pushNamed(
                            //               Routes.PLAYERPAGE,
                            //               arguments: {"link": season.stringId});
                            //         },
                            //       );
                            //     },
                            //     itemCount: timeline.seasons.length,
                            //   ),
                            // );
                          }),
                        ))
                      ],
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
