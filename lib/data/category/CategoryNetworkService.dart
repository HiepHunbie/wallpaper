import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper/model/category/CategoryData.dart';
import 'package:wallpaper/utils/Constants.dart';

class CategoryNetworkRepository implements CategoryRepository {
  @override
  Future<List<Category>> fetchCategorys(String phone,int page, int limit, int type) async {
    String url = BASE_URL + "posts?phone="+phone+"&page="+page.toString()+"&limit="+limit.toString()+"&type="+type.toString();
    http.Response response = await http.get(url);
    final statusCode = response.statusCode;
    var data = json.decode(response.body);
    var rest = data as List;
    if (statusCode != 200 || data == null) {
      throw new Exception(response.body.toString());
    }

    return rest.map<Category>((json) => Category.fromJson(json)).toList();
  }

}