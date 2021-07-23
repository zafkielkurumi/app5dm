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
        ChangeNotifierProvider<CustomThemeModel>(
            create: (_) => CustomThemeModel())
      ],
      child: Consumer<CustomThemeModel>(builder: (_, themeModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '5dm',
          theme: themeModel.themeData,
          // navigatorObservers: [
          //   FFNavigatorObserver(routeChange: ( newRoute,
          //        oldRoute) {
          //     // track page here
          //     var newRouteSettings = newRoute.settings;
          //     var oldRouteSettings = oldRoute.settings;
          //     if (newRouteSettings is FFRouteSettings &&
          //         oldRouteSettings is FFRouteSettings) {
          //       if (newRouteSettings?.showStatusBar !=
          //           oldRouteSettings?.showStatusBar) {
          //         if (newRouteSettings?.showStatusBar == true) {
          //           SystemChrome.setEnabledSystemUIOverlays(
          //               SystemUiOverlay.values);
          //           SystemChrome.setSystemUIOverlayStyle(
          //               SystemUiOverlayStyle.dark);
          //         } else {
          //           SystemChrome.setEnabledSystemUIOverlays([]);
          //         }
          //       }
          //     }
          //   })
          // ],
          builder: (c, w) {
            ScreenUtil.init(c, width: 750, height: 1334);
            MediaQueryData data = MediaQuery.of(c);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: 1.0),
              // 响应 theme变换statusbar
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarColor: themeModel.themeColor,
                    statusBarBrightness: themeModel.brightness,
                  ),
                  child: OrientationBuilder(builder: (_, orientaion) {
                    return SafeArea(
                        bottom: orientaion == Orientation.portrait,
                        top: orientaion == Orientation.portrait,
                        child: w);
                  })),
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
