import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/category/CategoryData.dart';

abstract class CategoryView{
  void onSuccess(List<Category> items);
  void onError(List<ErrorData> e);
}