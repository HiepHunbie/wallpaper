
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/LoadingImage.dart';
import 'package:wallpaper/components/home/ButtonTop.dart';
import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/home/HomeData.dart';
import 'package:wallpaper/ui/detail/DetailComponent.dart';
import 'package:wallpaper/utils/Alerts.dart';
import 'package:wallpaper/utils/Colors.dart';

import '../../app_localizations.dart';
import 'HomePresenter.dart';
import 'HomeView.dart';

class HomePageState extends State<HomePage> implements HomeView {

  BasicHomePresenter presenter;
  Alerts alerts;
  String _phone = "";
  int _page = 1;
  int _limit = 10;
  bool _stopLoadMore = false;
  bool _isLoading;
  bool _isLoadMore = false;
  int _type = 1;
  bool _typeClick = true;
  List<Home> _homes = new List();

  HomePageState() {
    presenter = new BasicHomePresenter(this);
    alerts = new Alerts();
  }

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = true;
    _typeClick = true;
    presenter.loadHomes(_phone,_page,_limit,_type);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: _homeWidget()
    );
  }

  Widget _homeWidget(){
    return new Container(
        color: Color(BACK_MAIN),
        child: new Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topCenter,
                  child: new Column(
                    children: <Widget>[
                      _topView(),
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

  Widget _topView(){
    return new Container(
      width: double.infinity,
      height: 32,
      margin: EdgeInsets.all(10),
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Container(
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(6.0),
                    side: BorderSide(color: Color(TAB_HIDE))),
                onPressed: () => clickTopButton(true),
                color: _typeClick?Color(YELLOW):Color(BACK_MAIN),
                padding: EdgeInsets.only(top:10.0,bottom: 10),
                child: Row( // Rep
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 5,left: 5),
                          child: SvgPicture.asset("images/ic_new_wall.svg",
                              color: _typeClick?Color(BACK_MAIN):Color(WHITE))
                      ),
                      Text(AppLocalizations.current.translate('popular'),
                          style: TextStyle(color: _typeClick?Color(BACK_MAIN):Color(WHITE),
                              fontSize: 13,
                              fontStyle: FontStyle.normal)),]),),
              margin: EdgeInsets.only(right: 5),
            ),),
          Expanded(
              flex: 1,
              child: new Container(
                child:new FlatButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(6.0),
                      side: BorderSide(color: Color(TAB_HIDE))),
                  onPressed: () => clickTopButton(false),
                  color: !_typeClick?Color(YELLOW):Color(BACK_MAIN),
                  padding: EdgeInsets.only(top:10.0,bottom: 10),
                  child: Row( // Rep
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 5,left: 5),
                            child: SvgPicture.asset("images/ic_popular.svg",
                                color: !_typeClick?Color(BACK_MAIN):Color(WHITE))
                        ),
                        Text(AppLocalizations.current.translate('new_wallpaper_big'),
                            style: TextStyle(color: !_typeClick?Color(BACK_MAIN):Color(WHITE),
                                fontSize: 13,
                                fontStyle: FontStyle.normal)),]),),
                margin: EdgeInsets.only(left: 5),))
        ],
      ),
    );
  }

  void clickTopButton(bool tab){
    setState(() {
      _typeClick = tab;
    });
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
                children: new List.generate(  _homes.length,(index){
                  return _getCardItemUi(context, _homes[index]);
                }
                ),
              ),
            )
        ));
  }
  Widget _getCardItemUi(BuildContext context, Home home) {
    return new GestureDetector(
        onTap: () =>Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(image: "https://placeimg.com/500/500/any",))),
        child: new Card(
            color: Color(BACK_MAIN),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(BACK_MAIN), width: 0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: new Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child:
                LoadingImage(url:"https://placeimg.com/500/500/any" ,)
              ),
            ) ));
  }
  void loadMore() {
    setState(() {
      _isLoadMore= true;
      _isLoading = true;
      _page+=1;
      presenter.loadHomes(_phone,_page,_limit,_type);
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
  void onSuccess(List<Home> items) {
    setState(() {
      if(items.length<_limit){
        _stopLoadMore = true;
      }
      if(_isLoadMore){
        _homes.addAll(items);
      }else{
        _homes = items;
      }
      _isLoadMore= false;
      _isLoading = false;
    });
  }
}
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}