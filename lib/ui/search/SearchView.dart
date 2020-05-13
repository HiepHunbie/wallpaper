import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/search/SearchData.dart';

abstract class SearchView{
  void onSuccess(List<Search> items);
  void onError(List<ErrorData> e);
}