import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/bottom_navbar_bloc.dart';
import 'package:news/screens/tabs/home_screen.dart';
import 'package:news/screens/tabs/search_screen.dart';
import 'package:news/screens/tabs/sources_screen.dart';
import 'package:news/style/theme.dart' as Style;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Style.ColorsApp.mainColor,
        title: Text(
          "News App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomeScreen();
            case NavBarItem.Sources:
              return SourcesScreen();
            case NavBarItem.Search:
              return SearchScreen();
          }
          return Container();
        },
      ),
      bottomNavigationBar: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavyBar(
            selectedIndex: snapshot.data!.index,
            onItemSelected: _bottomNavBarBloc.pickItem,
            items: [
              BottomNavyBarItem(icon: Icon(CupertinoIcons.home),title: Text("Home"),activeColor: Style.ColorsApp.mainColor),
              BottomNavyBarItem(icon: Icon(EvaIcons.grid),title: Text("Sources"),activeColor: Style.ColorsApp.mainColor),
              BottomNavyBarItem(icon: Icon(CupertinoIcons.search),title: Text("Search"),activeColor: Style.ColorsApp.mainColor),
            ],
          );
        } ,
      ),
    );
  }
}
