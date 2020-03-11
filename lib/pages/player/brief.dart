import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/playerProvider.dart';
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
    PlayerModel _model = Provider.of<PlayerModel>(context, listen: false);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Selector<PlayerModel, String>(
            //   selector: (_, playerModel) => playerModel.videoDetail.videoTitle,
            //   builder: (_, videoTitle, c) {
            //     return Text(videoTitle);
            //   },
            // ),
            IconButton(icon: Icon(Icons.favorite_border), onPressed: null)
          ],
        ),
        // Selector<PlayerModel, String>(
        //   selector: (_, playerModel) => playerModel.videoDetail.brief,
        //   builder: (_, brief, c) {
        //     return Text(brief);
        //   },
        // ),
        RaisedButton(onPressed: () {
          _model.testchangePinHeight();
        }, child: Text('data'),),
        // Selector<PlayerModel, List<Sources>>(
        //   selector: (_, playerModel) => playerModel.videoDetail.sources,
        //   shouldRebuild: (prev, next) => false,
        //   builder: (_, sources, c) {
        //     return Column(
        //       children: List.generate(sources.length, (index) {
        //         Sources source = sources[index];
        //         return Container(
        //           child: SourceWidget(source: source),
        //         );
        //       }),
        //     );
        //   },
        // ),
      ],
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
          onTap: () {},
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
          height: 30,
          child: ListView.builder(
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

  OutlineButton buildOutlineButton(BuildContext context, Links link, String currentlink) {
    return currentlink == link.link ? OutlineButton(
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
      onPressed: () {
        Provider.of<PlayerModel>(context, listen: false).changeLink(link.link);
      },
      child: Text(link.title) ,
    ) : OutlineButton(
      onPressed: () {
        Provider.of<PlayerModel>(context, listen: false).changeLink(link.link);
      },
      child: Text(link.title, style: TextStyle(color: Colors.black45),) ,
    ) ;
  }
}
