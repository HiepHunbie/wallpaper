
import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaper/components/AutoCompleteTextFeild.dart';
import 'package:wallpaper/components/EmptyAppBar.dart';
import 'package:wallpaper/components/LoadingImage.dart';
import 'package:wallpaper/model/ErrorData.dart';
import 'package:wallpaper/model/search/SearchData.dart';
import 'package:wallpaper/ui/detail/DetailComponent.dart';
import 'package:wallpaper/utils/Alerts.dart';
import 'package:wallpaper/utils/Colors.dart';

import '../../app_localizations.dart';
import 'SearchPresenter.dart';
import 'SearchView.dart';

class SearchPageState extends State<SearchPage> implements SearchView {

  BasicSearchPresenter presenter;
  Alerts alerts;
  String _phone = "";
  int _page = 1;
  int _limit = 10;
  bool _stopLoadMore = false;
  bool _isLoading;
  bool _isLoadMore = false;
  int _type = 1;
  List<Search> _searchs = new List();
  List<String> suggestionsList = List();
  String textSearch = "";
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Search>> key = new GlobalKey();
  Search selected;

  SearchPageState() {
    presenter = new BasicSearchPresenter(this);
    alerts = new Alerts();
    searchTextField = AutoCompleteTextField<Search>(
      key: key,
      clearOnSubmit: false,
      suggestions: _searchs,
      style: TextStyle(color: Color(WHITE), fontSize: 12.0),
      decoration: new InputDecoration(
        filled: true,
        fillColor: Color(BORDER_SEARCH),
        contentPadding: EdgeInsets.only(left: 10),
        labelStyle: TextStyle(
          color: Color(WHITE),
          fontSize: 12.0,
        ),
        hintText: AppLocalizations.current.translate('search_hint'),
        hintStyle: TextStyle(
          color: Color(WHITE),
          fontSize: 12.0,
        ),
        focusColor: Color(BORDER_SEARCH),
//          contentPadding: new EdgeInsets.all(10.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDER_SEARCH)),
          borderRadius: BorderRadius.circular(6),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDER_SEARCH)),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(BORDER_SEARCH)),
          borderRadius: BorderRadius.circular(6),
        ),
        suffixIcon: new Padding(padding: EdgeInsets.all(0),
            child: IconButton(
                icon: SvgPicture.asset("images/ic_search.svg",
                    color:Color(WHITE)),
                onPressed: () => searchData(this.textSearch))),
      ),
      itemFilter: (item, query) {
        return item.name
            .toLowerCase()
            .startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) => a.name.compareTo(b.name),
      itemSubmitted: (item) {
        setState(() {
          searchTextField.textField.controller.text = item.name;
          textSearch = item.phone;
          selected = item;
        });
        searchData(this.textSearch);
      },
      itemBuilder: (context, item) {
        // ui for the autocompelete row
        return row(item);
      },
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    _isLoading = true;
    presenter.loadSearchs(_phone,_page,_limit,_type);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        primary: true,
        appBar: EmptyAppBar(),
        body: _SearchWidget()
    );
  }

  Widget _SearchWidget(){
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

  Widget row(Search search) {
    return
      Padding(padding: EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            search.name,
            style: TextStyle(fontSize: 12.0),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            search.phone,
          ),
        ],
      ),)
      ;
  }

  Widget _topView(){
    return new Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.all(10),
      child:
     searchTextField
    );
  }

  void searchData(String phone) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoadMore= false;
      _isLoading = true;
      _phone = phone;
      _page=1;
      presenter.loadSearchs(_phone,_page,_limit,_type);
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
                children: new List.generate(  _searchs.length,(index){
                  return _getCardItemUi(context, _searchs[index]);
                }
                ),
              ),
            )
        ));
  }
  Widget _getCardItemUi(BuildContext context, Search Search) {
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
      presenter.loadSearchs(_phone,_page,_limit,_type);
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
  void onSuccess(List<Search> items) {
    setState(() {
      if(items.length<_limit){
        _stopLoadMore = true;
      }
      if(_isLoadMore){
        _searchs.addAll(items);
      }else{
        _searchs = items;
      }
      searchTextField.updateSuggestions(_searchs);
      _isLoadMore= false;
      _isLoading = false;
    });
  }
}
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SearchPageState();
  }
}
