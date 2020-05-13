import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/rate/RateData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'RateView.dart';


class RatePresenter{
}

class BasicRatePresenter implements RatePresenter{
  RateView _rateView;
  RateRepository _repository;
  ErrorResponse errorResponse = new ErrorResponse();
  BasicRatePresenter(this._rateView) {
    _repository = new Injector().rateRepository;
  }

  void loadRates(String phone,int page, int litmit,int type) {
    _repository
        .fetchRates(phone,page,litmit,type)
        .then((data) => _rateView.onSuccess(data))
        .catchError((e) => _rateView.onError(errorResponse.getError(e.toString())));
  }


  @override
  set rateView(RateView value) {
    _rateView = value;
  }


}