import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/home/HomeData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'HomeView.dart';


class HomePresenter{
}

class BasicHomePresenter implements HomePresenter{
  HomeView _homeView;
  HomeRepository _repository;
  ErrorResponse errorResponse = new ErrorResponse();

  BasicHomePresenter(this._homeView) {
    _repository = new Injector().homeRepository;
  }

  void loadHomes(String phone,int page, int litmit,int type) {
    _repository
        .fetchHomes(phone,page,litmit,type)
        .then((data) => _homeView.onSuccess(data))
        .catchError((e) => _homeView.onError(errorResponse.getError(e.toString())));
  }

  @override
  set homeView(HomeView value) {
    _homeView = value;
  }


}