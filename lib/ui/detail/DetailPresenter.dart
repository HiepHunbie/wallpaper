import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'DetailView.dart';


class DetailPresenter{
}

class BasicDetailPresenter implements DetailPresenter{
  DetailView _DetailView;

  @override
  set DetailView(DetailView value) {
    _DetailView = value;
  }


}