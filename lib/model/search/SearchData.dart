import 'dart:async';

import 'dart:convert';


class Search {
  int id;
  String phone;
  String name;
  String address;
  String history;
  dynamic bohaDate;
  int type;
  String userId;
  int totalDislike;
  int totalComment;
  DateTime createdAt;
  DateTime updatedAt;

  Search({
    this.id,
    this.phone,
    this.name,
    this.address,
    this.history,
    this.bohaDate,
    this.type,
    this.userId,
    this.totalDislike,
    this.totalComment,
    this.createdAt,
    this.updatedAt,
  });

  factory Search.fromRawJson(String str) => Search.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    id: json["id"],
    phone: json["phone"],
    name: json["name"],
    address: json["address"],
    history: json["history"],
    bohaDate: json["boha_date"],
    type: json["type"],
    userId: json["user_id"],
    totalDislike: json["total_dislike"],
    totalComment: json["total_comment"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "name": name,
    "address": address,
    "history": history,
    "boha_date": bohaDate,
    "type": type,
    "user_id": userId,
    "total_dislike": totalDislike,
    "total_comment": totalComment,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


abstract class SearchRepository {
  Future<List<Search>> fetchSearchs(String phone,int page, int litmit, int type);
}

class DataSearchs {

  List<dynamic> data;
  String message;
  int status;

  DataSearchs({this.data, this.message, this.status});

  DataSearchs.fromMap(Map<String, dynamic> map)
      : data = map['data'],
        message = map['message'],
        status = map['status'];
}

