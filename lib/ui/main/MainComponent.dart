import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/utils/Colors.dart';
import 'package:wallpaper/ui/home/HomeComponent.dart';
import 'package:wallpaper/ui/category/CategoryComponent.dart';
import 'package:wallpaper/ui/rate/RateComponent.dart';
import 'package:wallpaper/ui/search/SearchComponent.dart';
import 'MainPresenter.dart';
import 'MainView.dart';

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin implements MainView {

  BasicMainPresenter presenter;
  TabController _tabController;
  int _currentIndex = 0;
  MainPageState(){
    presenter = new BasicMainPresenter(this);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _handleTabSelection() {
      setState(() {
        _currentIndex = _tabController.index;
      });
      _tabController.animateTo(_currentIndex);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Color(BACK_MAIN),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              HomePage(),
              CategoryPage(),
              RatePage(),
              SearchPage(),
            ],
          ),
          bottomNavigationBar:
          new Container(
            height: 45,
            child: new TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: SvgPicture.asset("images/ic_home.svg",
                color: _currentIndex == 0
                    ? Color(YELLOW)
                    : Color(TAB_HIDE))
                ),
                Tab(
                    icon: SvgPicture.asset("images/ic_list.svg",
                        color: _currentIndex == 1
                            ? Color(YELLOW)
                            : Color(TAB_HIDE))
                ),
                Tab(
                    icon: SvgPicture.asset("images/ic_rate.svg",
                        color: _currentIndex == 2
                            ? Color(YELLOW)
                            : Color(TAB_HIDE))
                ),
                Tab(
                    icon: SvgPicture.asset("images/ic_search.svg",
                        color: _currentIndex == 3
                            ? Color(YELLOW)
                            : Color(TAB_HIDE))
                ),
              ],
              labelColor: Colors.yellow,
              unselectedLabelColor: Colors.blue,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: Color(YELLOW),
            ),
          ),
        ),
      ),
    );
  }
}
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}