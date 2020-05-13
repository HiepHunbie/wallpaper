
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/LoadingImage.dart';
import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/category/CategoryData.dart';
import 'package:wallpaper/ui/album/AlbumComponent.dart';
import 'package:wallpaper/utils/Alerts.dart';
import 'package:wallpaper/utils/Colors.dart';

import 'CategoryPresenter.dart';
import 'CategoryView.dart';

class CategoryPageState extends State<CategoryPage> implements CategoryView {

  BasicCategoryPresenter presenter;
  Alerts alerts;
  String _phone = "";
  int _page = 1;
  int _limit = 10;
  bool _stopLoadMore = false;
  bool _isLoading;
  bool _isLoadMore = false;
  int _type = 1;
  List<Category> _Categorys = new List();

  CategoryPageState() {
    presenter = new BasicCategoryPresenter(this);
    alerts = new Alerts();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    presenter.loadCategorys(_phone,_page,_limit,_type);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: _CategoryWidget()
    );
  }

  Widget _CategoryWidget(){
    return new Container(
        color: Color(BACK_MAIN),
        child: new Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topCenter,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _listData()
                    ],
                  )),
              _isLoading
                  ? new Container(
                alignment: Alignment.center,
                color: Color(BACK_TRANS_LOADING),
                width: double.infinity,
                height: double.infinity,
                child: new CircularProgressIndicator(),
              )
                  : new Container(),
            ],
          ),)
    );
  }


  Widget _listData(){
    return new Flexible(
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_stopLoadMore&&!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                loadMore();
              }
            },
            child:new Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: GridView.count(
                childAspectRatio: 168/192,
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: new List.generate(  _Categorys.length,(index){
                  return _getCardItemUi(context, _Categorys[index]);
                }
                ),
              ),
            )
        ));
  }
  Widget _getCardItemUi(BuildContext context, Category category) {
    return new GestureDetector(
        onTap: () =>Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlbumPage(title: category.name,))),
        child: new Card(
            color: Color(BACK_MAIN),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(TRANS), width: 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child:new Container(
                    height: 200,
                    child: new Stack(
                      children: <Widget>[
                        LoadingImage(url:"https://placeimg.com/500/500/any" ,),
                        Expanded(
                          child:Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: new Container(
                              height: 34,
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.bottomCenter,
                              child:  Stack(children: <Widget>[
                                Align(alignment: Alignment.centerLeft,
                                  child: Text(category.name,
                                      style: TextStyle(color: Color(WHITE),
                                        fontSize: 10,
                                        fontFamily: 'Montserrat Bold',
                                        fontWeight: FontWeight.bold,)),),
                                Align(alignment: Alignment.centerRight,
                                  child: Text(category.id.toString(),
                                      style: TextStyle(color: Color(WHITE),
                                        fontSize: 8,
                                        fontFamily: 'Montserrat Regular',)),),
                              ],),
                              color: Color(BACK_ITEM),
                            ),
                          ),)],
                    )
                ) )));
  }
  void loadMore() {
    setState(() {
      _isLoadMore= true;
      _isLoading = true;
      _page+=1;
      presenter.loadCategorys(_phone,_page,_limit,_type);
    });
  }
  @override
  void onError(List<ErrorData> e) {
    setState(() {
      this._isLoading = false;
    });
    alerts.showAlertError(context,e);
  }

  @override
  void onSuccess(List<Category> items) {
    setState(() {
      if(items.length<_limit){
        _stopLoadMore = true;
      }
      if(_isLoadMore){
        _Categorys.addAll(items);
      }else{
        _Categorys = items;
      }
      _isLoadMore= false;
      _isLoading = false;
    });
  }
}
class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CategoryPageState();
  }
}