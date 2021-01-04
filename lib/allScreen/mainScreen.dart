import 'package:driver_app/tabsPages/earningsTabPage.dart';
import 'package:driver_app/tabsPages/homeTabPage.dart';
import 'package:driver_app/tabsPages/profileTabPage.dart';
import 'package:driver_app/tabsPages/ratingtabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen='mainScreen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController tabController;
  int selectedIndex=0;

  void onItemClicked(int index)
  {
    setState(() {
      selectedIndex=index;
      tabController.index=selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController=TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
      children: [
          HomeTabPage(),
        EarningTabPage(),
        ProfileTabPage(),
        RatingTabPage()
      ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
               icon: Icon(Icons.home),
                label:'Home'
               ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label:'Earnings'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label:'Rating'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label:'Account'
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.yellow,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
