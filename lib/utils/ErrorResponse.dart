import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/model/ErrorData.dart';

class ErrorResponse{

  ErrorResponse(){

  }

  List<ErrorData> getError(String dataResult){
    var data = json.decode(dataResult.replaceAll("Exception:", "").trim());
    var rest = data as List;

    return rest.map<ErrorData>((json) => ErrorData.fromJson(json)).toList();
  }
}