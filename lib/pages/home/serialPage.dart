import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/models/index.dart';
import 'package:app5dm/providers/serialProvider.dart';
import 'package:app5dm/utils/index.dart';
import 'package:app5dm/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:provider/provider.dart';

@FFRoute(
  name: "/serialPage",
  routeName: "serialPage",
  argumentNames: ["link", "title"],
  showStatusBar: false,
)
class SerialPage extends StatelessWidget {
  final String link;
  final String title;
  SerialPage({this.link, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: ChangeNotifierProvider<SerialModel>(
        create: (_) => SerialModel(link),
        child: ViewWidget<SerialModel>(
            skelelon: SkeletonGirdList(),
            child: Selector<SerialModel, List<Seasons>>(
              selector: (_, serialModel) => serialModel.serials,
              builder: (_, serials, child) {
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: serials.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: Screen.setWidth(20),
                      mainAxisSpacing: 0),
                  itemBuilder: (_, index) {
                    return Selector<SerialModel, Seasons>(
                      selector: (_, serialModel) => serialModel.serials[index],
                      builder: (_, serial, child) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.PLAYERPAGE,
                              arguments: {"link": serial.stringId},
                            );
                          },
                          child: Container(
                            child: VideoItemIntroduce(
                              imgUrl: serial.imgUrl,
                              title: serial.title,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )),
      ),
    );
  }
}
