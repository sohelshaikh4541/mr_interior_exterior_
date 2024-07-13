
class CityDropModel {
  String? message;
  bool? status;
  List<Cities>? cities;

  CityDropModel({this.message, this.status, this.cities});

  CityDropModel.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["cities"] is List) {
      cities = json["cities"] == null ? null : (json["cities"] as List).map((e) => Cities.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(cities != null) {
      _data["cities"] = cities?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Cities {
  int? id;
  String? name;
  int? stateId;
  dynamic createdAt;
  dynamic updatedAt;

  Cities({this.id, this.name, this.stateId, this.createdAt, this.updatedAt});

  Cities.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["state_id"] is int) {
      stateId = json["state_id"];
    }
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["state_id"] = stateId;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}
