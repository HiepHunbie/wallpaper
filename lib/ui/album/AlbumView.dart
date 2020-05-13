import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/album/AlbumData.dart';

abstract class AlbumView{
  void onSuccess(List<Album> items);
  void onError(List<ErrorData> e);
}