import 'dart:async';

enum NavBarItem { HOME, Sources, Search }

class BottomNavBarBloc {
  // we make it broadcast because both of body and navigation bar will listen to it..
  StreamController<NavBarItem> _navBarController = StreamController.broadcast();
  NavBarItem defaultItem = NavBarItem.HOME;

  // to get the stream of NavBarItem..
  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.HOME);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.Sources);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.Search);
        break;
    }
  }

  // to close stream when not needed..
  close() {
    _navBarController.close();
  }
}
