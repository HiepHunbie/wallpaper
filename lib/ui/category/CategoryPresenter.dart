import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/category/CategoryData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'CategoryView.dart';


class CategoryPresenter{
}

class BasicCategoryPresenter implements CategoryPresenter{
  CategoryView _categoryView;
  CategoryRepository _repository;
  ErrorResponse errorResponse = new ErrorResponse();
  BasicCategoryPresenter(this._categoryView) {
    _repository = new Injector().categoryRepository;
  }

  void loadCategorys(String phone,int page, int litmit,int type) {
    _repository
        .fetchCategorys(phone,page,litmit,type)
        .then((data) => _categoryView.onSuccess(data))
        .catchError((e) => _categoryView.onError(errorResponse.getError(e.toString())));
  }


  @override
  set categoryView(CategoryView value) {
    _categoryView = value;
  }


}