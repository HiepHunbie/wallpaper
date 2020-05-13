import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper/app_localizations.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/ZoomLoadingImage.dart';
import 'package:wallpaper/utils/Colors.dart';
import 'package:wallpaper/utils/DownloadImage.dart';
import 'DetailView.dart';

class DetailPageState extends State<DetailPage> implements DetailView {

  String image = "";
  bool _isLoading;
  DownloadImage downloadImage ;
  bool _isDownloading;

  DetailPageState(String image) {
    this.image = image;
  }
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isDownloading = false;
    downloadImage = new DownloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      primary: true,
      appBar:  EmptyAppBar (),
      body: _viewWidget(),
    );
  }

  Widget _viewWidget(){
    return Container(
      padding: EdgeInsets.only(top: 8,bottom: 8),
      decoration: BoxDecoration(color: Color(BACK_MAIN)),
      child: Stack(
        children: <Widget>[
          Align(alignment: Alignment.center,
            child: new Container(
                alignment: Alignment.center,
                child: ZoomLoadingImage(url: "https://placeimg.com/500/500/any",),))
          ,
          _isDownloading?Align(alignment: Alignment.topCenter,
            child: Text(AppLocalizations.current.translate('image_saved'),
                style: TextStyle(fontSize: 14,
                    fontFamily: 'Montserrat Regular',
                    fontWeight: FontWeight.bold,
                color: Color(WHITE))),)
          :new Container(),
          Align(alignment: Alignment.bottomCenter,
            child: _buttonBottom(),)
          ,
        ],
      ),
    );
  }
  Widget _buttonBottom(){
    return Container(
      height: 50,
      color: Color(BACK_MAIN),
      padding: EdgeInsets.only(top: 2,bottom: 2),
      child: new Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset("images/ic_back.svg",
                  color: Color(TAB_HIDE)),
              tooltip: "Navigation Menu",
              onPressed: ()=> Navigator.pop(context),
            ),
            IconButton(
              icon: Image.asset("images/ic_download.png"),
              tooltip: "Navigation Menu",
              onPressed: ()=> downloadImage.downloadImage( "https://placeimg.com/500/500/any").whenComplete(() => toastDownloaded()),
            ),
            IconButton(
              icon: SvgPicture.asset("images/ic_album.svg",
                  color: Color(TAB_HIDE)),
              tooltip: "Navigation Menu",
              onPressed: ()=> {},
            ),
          ],
        ),
      )
    );
  }

}

void toastDownloaded(){
  Fluttertoast.showToast(
      msg: AppLocalizations.current.translate('image_saved'),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(BACK_MAIN),
      textColor: Colors.white,
      fontSize: 14.0
  );
}

class DetailPage extends StatefulWidget {
  final String image;
  // In the constructor, require a Todo.
  DetailPage({Key key, @required this.image}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new DetailPageState(image);
  }
}