
class GetSalesPartner {
  String? message;
  bool? status;
  List<Users>? users;

  GetSalesPartner({this.message, this.status, this.users});

  GetSalesPartner.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["users"] is List) {
      users = json["users"] == null ? null : (json["users"] as List).map((e) => Users.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(users != null) {
      _data["users"] = users?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Users {
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

  Users({this.id, this.name, this.mobile, this.email, this.gender, this.usertype, this.salesby, this.address, this.city, this.state, this.pinCode, this.date, this.profilePic});

  Users.fromJson(Map<String, dynamic> json) {
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