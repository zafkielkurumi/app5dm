import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/playerProvider.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Brief extends StatefulWidget {
  const Brief({
    Key key,
  }) : super(key: key);

  @override
  _BriefState createState() => _BriefState();
}

class _BriefState extends State<Brief> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollViewInnerScrollPositionKeyWidget(
      Key('tab0'),
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Selector<PlayerModel, String>(
                selector: (_, playerModel) =>
                    playerModel.videoDetail.title,
                builder: (_, videoTitle, c) {
                  return Text(
                    videoTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              )),
              IconButton(icon: Icon(Icons.favorite_border), onPressed: null)
            ],
          ),
          Selector<PlayerModel, String>(
            selector: (_, playerModel) => playerModel.videoDetail.brief,
            builder: (_, brief, c) {
              return Text(brief);
            },
          ),
          Selector<PlayerModel, List<Sources>>(
            selector: (_, playerModel) => playerModel.videoDetail.sources,
            shouldRebuild: (prev, next) => false,
            builder: (_, sources, c) {
              return Column(
                children: List.generate(sources.length, (index) {
                  Sources source = sources[index];
                  return Container(
                    child: SourceWidget(source: source),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SourceWidget extends StatelessWidget {
  const SourceWidget({
    Key key,
    @required this.source,
  }) : super(key: key);

  final Sources source;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Provider.of<PlayerModel>(context, listen: false).showModelSheet();
          },
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(source.sourceTitle),
                  Row(
                    children: <Widget>[
                      Text('共${source.links.length}话'),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  )
                ],
              )),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ListView.builder(
            // controller: briefSc, todo
              scrollDirection: Axis.horizontal,
              itemCount: source.links.length,
              itemBuilder: (ctx, index) {
                var link = source.links[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Selector<PlayerModel, String>(
                    selector: (_, playerModel) => playerModel.link,
                    builder: (_, currentlink, c) {
                      return buildOutlineButton(context, link, currentlink);
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  OutlineButton buildOutlineButton(
      BuildContext context, Links link, String currentlink) {
    return currentlink == link.url
        ? OutlineButton(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            onPressed: () {
              Provider.of<PlayerModel>(context, listen: false)
                  .changeLink(link.url);
            },
            child: Text(link.title),
          )
        : OutlineButton(
            onPressed: () {
              Provider.of<PlayerModel>(context, listen: false)
                  .changeLink(link.url);
            },
            child: Text(
              link.title,
              style: TextStyle(color: Colors.black45),
            ),
          );
  }
}
