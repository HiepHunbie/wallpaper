import 'MainView.dart';

class MainPresenter{
}

class BasicMainPresenter implements MainPresenter{
  MainView _mainView;

  BasicMainPresenter(this._mainView) {
  }

  @override
  set loginView(MainView value) {
    _mainView = value;
  }

}