import 'package:app5dm/app5dm_route.dart';
import 'package:app5dm/app5dm_route_helper.dart';
import 'package:app5dm/pages/noRoute.dart';
import 'package:app5dm/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:app5dm/utils/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
  NetUtil.init();
  runApp(MyApp());
      SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider<CustomThemeModel>(create: (_) => CustomThemeModel())
      ],
      child: Consumer<CustomThemeModel>(builder: (_, themeModel, child) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '5dm',
        theme: themeModel.themeData,
        navigatorObservers: [
          FFNavigatorObserver(routeChange:
              (RouteSettings newRouteSettings, RouteSettings oldRouteSettings) {
            // track page here
            if (newRouteSettings is FFRouteSettings &&
                oldRouteSettings is FFRouteSettings) {
              if (newRouteSettings?.showStatusBar !=
                  oldRouteSettings?.showStatusBar) {
                if (newRouteSettings?.showStatusBar == true) {
                  SystemChrome.setEnabledSystemUIOverlays(
                      SystemUiOverlay.values);
                  SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle.dark);
                } else {
                  SystemChrome.setEnabledSystemUIOverlays([]);
                }
              }
            }
          })
        ],
        builder: (c, w) {
          ScreenUtil.init(c, width: 750, height: 1334);
          var data = MediaQuery.of(c);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: w,
          );
        },
        // home: IndexPage(),
        initialRoute: Routes.APP5DM_SPLASHPAGE,
        onGenerateRoute: (RouteSettings settings) =>
            onGenerateRouteHelper(settings, notFoundFallback: NoRoute()),
      );
      }),
    ));
  }
}
