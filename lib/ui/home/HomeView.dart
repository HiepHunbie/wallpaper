import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/home/HomeData.dart';

abstract class HomeView{
  void onSuccess(List<Home> items);
  void onError(List<ErrorData> e);
}