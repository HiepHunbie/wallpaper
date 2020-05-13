import 'dart:convert';

import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/album/AlbumData.dart';
import 'package:wallpaper/utils/ErrorResponse.dart';
import '../di.dart';
import 'AlbumView.dart';


class AlbumPresenter{
}

class BasicAlbumPresenter implements AlbumPresenter{
  AlbumView _AlbumView;
  AlbumRepository _repository;
  ErrorResponse errorResponse = new ErrorResponse();
  BasicAlbumPresenter(this._AlbumView) {
    _repository = new Injector().albumRepository;
  }

  void loadAlbums(String phone,int page, int litmit,int type) {
    _repository
        .fetchAlbums(phone,page,litmit,type)
        .then((data) => _AlbumView.onSuccess(data))
        .catchError((e) => _AlbumView.onError(errorResponse.getError(e.toString())));
  }

  @override
  set albumView(AlbumView value) {
    _AlbumView = value;
  }


}