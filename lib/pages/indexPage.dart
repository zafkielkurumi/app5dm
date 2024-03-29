import 'package:flutter/material.dart';
import 'package:app5dm/pages/home/home.dart';
import 'package:app5dm/pages/timetablePage.dart';
// import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:oktoast/oktoast.dart';


// @FFRoute(
//   name: "app5dm://homePage",
//   routeName: "homePage",
//   showStatusBar: true
// )

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<Widget> _pages = [HomePage(), Timetable()];
  final List<BottomNavigationBarItem> _bottomBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(Icons.timeline), title: Text('时间表')),
  ];
  final PageController _pageController = PageController();

  DateTime currentBackPressTime;
  int currentPageIndex = 0;

   Future<bool> _onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast('再按一次退出');
      return Future.value(false);
    }
    return Future.value(true);
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: PageView(
            controller: _pageController,
            children: _pages,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                currentPageIndex = value;
              });
            },
          ),
          onWillPop: _onWillPop),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomBarItems,
        currentIndex: currentPageIndex,
        onTap: (int index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
