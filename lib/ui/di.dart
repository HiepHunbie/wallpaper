import 'package:wallpaper/data/album/AlbumNetworkService.dart';
import 'package:wallpaper/data/category/CategoryNetworkService.dart';
import 'package:wallpaper/data/home/HomeNetworkService.dart';
import 'package:wallpaper/data/rate/RateNetworkService.dart';
import 'package:wallpaper/data/search/SearchNetworkService.dart';
import 'package:wallpaper/model/album/AlbumData.dart';
import 'package:wallpaper/model/category/CategoryData.dart';
import 'package:wallpaper/model/home/HomeData.dart';
import 'package:wallpaper/model/rate/RateData.dart';
import 'package:wallpaper/model/search/SearchData.dart';

class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  HomeRepository get homeRepository => new HomeNetworkRepository();
  CategoryRepository get categoryRepository => new CategoryNetworkRepository();
  AlbumRepository get albumRepository => new AlbumNetworkRepository();
  RateRepository get rateRepository => new RateNetworkRepository();
  SearchRepository get searchRepository => new SearchNetworkRepository();
}