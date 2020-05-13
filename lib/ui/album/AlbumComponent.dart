
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/LoadingImage.dart';
import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/album/AlbumData.dart';
import 'package:wallpaper/ui/main/MainComponent.dart';
import 'package:wallpaper/utils/Alerts.dart';
import 'package:wallpaper/utils/Colors.dart';
import 'package:wallpaper/ui/detail/DetailComponent.dart';
import '../../app_localizations.dart';
import 'AlbumPresenter.dart';
import 'AlbumView.dart';

class AlbumPageState extends State<AlbumPage> implements AlbumView {

  BasicAlbumPresenter presenter;
  Alerts alerts;
  String _phone = "";
  int _page = 1;
  int _limit = 10;
  bool _stopLoadMore = false;
  bool _isLoading;
  bool _isLoadMore = false;
  int _type = 1;
  List<Album> _Albums = new List();
  String title = "";

  AlbumPageState(String title) {
    presenter = new BasicAlbumPresenter(this);
    alerts = new Alerts();
    this.title = title;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    presenter.loadAlbums(_phone,_page,_limit,_type);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: _AlbumWidget()
    );
  }

  Widget _AlbumWidget(){
    return new Container(
        color: Color(BACK_MAIN),
        child: new Padding(
          padding: EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topCenter,
                  child: new Column(
                    children: <Widget>[
                      _titleTop(),
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
                children: new List.generate(  _Albums.length,(index){
                  return _getCardItemUi(context, _Albums[index]);
                }
                ),
              ),
            )
        ));
  }
  Widget _getCardItemUi(BuildContext context, Album album) {
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
                child:  LoadingImage(url:"https://placeimg.com/500/500/any" ,),
              ),
            ) ));
  }

  Widget _titleTop(){
    return Container(
      height: 50,
      padding: EdgeInsets.only(top: 8,bottom: 8),
      decoration: BoxDecoration(color: Color(BACK_MAIN)),
      child: Stack(
        children: <Widget>[
          Align(alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Color(WHITE),size: 18,),
            tooltip: "Navigation Menu",
            onPressed: ()=>Navigator.pop(context),
          ),)
          ,
          Expanded(
              child: Align(alignment: Alignment.center,
                  child: Text(this.title,style: new TextStyle( fontSize: 13, fontFamily: 'Montserrat Medium',fontWeight: FontWeight.bold,color: Color(WHITE)),)
              )),
        ],
      ),
    );
  }
  void loadMore() {
    setState(() {
      _isLoadMore= true;
      _isLoading = true;
      _page+=1;
      presenter.loadAlbums(_phone,_page,_limit,_type);
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
  void onSuccess(List<Album> items) {
    setState(() {
      if(items.length<_limit){
        _stopLoadMore = true;
      }
      if(_isLoadMore){
        _Albums.addAll(items);
      }else{
        _Albums = items;
      }
      _isLoadMore= false;
      _isLoading = false;
    });
  }
}
class AlbumPage extends StatefulWidget {
  final String title;
  AlbumPage({Key key, @required this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new AlbumPageState(this.title);
  }
}