import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/rate/RateData.dart';

abstract class RateView{
  void onSuccess(List<Rate> items);
  void onError(List<ErrorData> e);
}