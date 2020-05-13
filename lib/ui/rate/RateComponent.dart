
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/LoadingImage.dart';
import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/rate/RateData.dart';
import 'package:wallpaper/ui/album/AlbumComponent.dart';
import 'package:wallpaper/utils/Alerts.dart';
import 'package:wallpaper/utils/Colors.dart';

import '../../app_localizations.dart';
import 'RatePresenter.dart';
import 'RateView.dart';

class RatePageState extends State<RatePage> implements RateView {

  BasicRatePresenter presenter;
  Alerts alerts;
  String _phone = "";
  int _page = 1;
  int _limit = 10;
  bool _stopLoadMore = false;
  bool _isLoading;
  bool _isLoadMore = false;
  int _type = 1;
  List<Rate> _rates = new List();

  RatePageState() {
    presenter = new BasicRatePresenter(this);
    alerts = new Alerts();
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    presenter.loadRates(_phone,_page,_limit,_type);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: _RateWidget()
    );
  }

  Widget _RateWidget(){
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
              child: new ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Color(WHITE),
                ),
                itemCount: _rates.length,
                itemBuilder: (BuildContext context, int index) {
                  final Rate rate = _rates[index];
                  return _getCardItemUi(context, rate);
                },
              ),
            )
        ));
  }
  Widget _getCardItemUi(BuildContext context, Rate rate) {
    return new GestureDetector(
        onTap: () =>{},
        child: new Card(
            elevation: 0,
            color: Color(BACK_MAIN),
            child: new Container(
                height: 65,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        flex: 48,
                        child:ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child:new Container(
                          height: 48,
                          child: LoadingImage(url:"https://placeimg.com/500/500/any" ,),
                        ))),
                    Expanded(
                        flex: 200,
                        child:new Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          alignment: Alignment.centerLeft,
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          Align(alignment: Alignment.centerLeft,
                            child:Text(rate.name,
                                  style: TextStyle(color: Color(WHITE),
                                      fontSize: 13,
                                      fontStyle: FontStyle.normal)),),
                              Align(alignment: Alignment.centerLeft,
                              child:Text(rate.id.toString(),
                                  style: TextStyle(color:Color(WHITE),
                                      fontSize: 13,
                                      fontStyle: FontStyle.normal)),)
                            ],
                          ),
                        ))
                    ,
                    Expanded(
                        flex: 64,
                        child:new Container(
                          height: 24,
                          child: new FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                side: BorderSide(color: Color(TAB_HIDE))),
                            onPressed: () => {},
                            color: Color(WHITE),
                            child: Row( // Rep
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(AppLocalizations.current.translate('install_big'),
                                      style: TextStyle(color: Color(BACK_MAIN),
                                          fontSize: 9,
                                          fontStyle: FontStyle.normal)),]),),
                        ))
                  ],
                )
            ) ));
  }
  void loadMore() {
    setState(() {
      _isLoadMore= true;
      _isLoading = true;
      _page+=1;
      presenter.loadRates(_phone,_page,_limit,_type);
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
  void onSuccess(List<Rate> items) {
    setState(() {
      if(items.length<_limit){
        _stopLoadMore = true;
      }
      if(_isLoadMore){
        _rates.addAll(items);
      }else{
        _rates = items;
      }
      _isLoadMore= false;
      _isLoading = false;
    });
  }
}
class RatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RatePageState();
  }
}