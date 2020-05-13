import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/search/SearchData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'SearchView.dart';


class SearchPresenter{
}

class BasicSearchPresenter implements SearchPresenter{
  SearchView _searchView;
  SearchRepository _repository;
  ErrorResponse errorResponse = new ErrorResponse();
  BasicSearchPresenter(this._searchView) {
    _repository = new Injector().searchRepository;
  }

  void loadSearchs(String phone,int page, int litmit,int type) {
    _repository
        .fetchSearchs(phone,page,litmit,type)
        .then((data) => _searchView.onSuccess(data))
        .catchError((e) => _searchView.onError(errorResponse.getError(e.toString())));
  }


  @override
  set searchView(SearchView value) {
    _searchView = value;
  }


}