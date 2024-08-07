
class ClientHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;

  ClientHistoryModel({this.success, this.message, this.data});

  ClientHistoryModel.fromJson(Map<String, dynamic> json) {
    if(json["success"] is bool) {
      success = json["success"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["success"] = success;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? gender;
  String? usertype;
  int? salesby;
  String? address;
  String? city;
  String? state;
  String? pinCode;
  String? date;
  String? profilePic;

  Data({this.id, this.name, this.mobile, this.email, this.gender, this.usertype, this.salesby, this.address, this.city, this.state, this.pinCode, this.date, this.profilePic});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["mobile"] is String) {
      mobile = json["mobile"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["usertype"] is String) {
      usertype = json["usertype"];
    }
    if(json["salesby"] is int) {
      salesby = json["salesby"];
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["city"] is String) {
      city = json["city"];
    }
    if(json["state"] is String) {
      state = json["state"];
    }
    if(json["pin_code"] is String) {
      pinCode = json["pin_code"];
    }
    if(json["date"] is String) {
      date = json["date"];
    }
    if(json["profile_pic"] is String) {
      profilePic = json["profile_pic"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["mobile"] = mobile;
    _data["email"] = email;
    _data["gender"] = gender;
    _data["usertype"] = usertype;
    _data["salesby"] = salesby;
    _data["address"] = address;
    _data["city"] = city;
    _data["state"] = state;
    _data["pin_code"] = pinCode;
    _data["date"] = date;
    _data["profile_pic"] = profilePic;
    return _data;
  }
}