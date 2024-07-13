
class StateDropModel {
  String? message;
  bool? status;
  List<States>? states;

  StateDropModel({this.message, this.status, this.states});

  StateDropModel.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["states"] is List) {
      states = json["states"] == null ? null : (json["states"] as List).map((e) => States.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(states != null) {
      _data["states"] = states?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class States {
  int? id;
  String? name;
  int? countryId;
  dynamic createdAt;
  dynamic updatedAt;

  States({this.id, this.name, this.countryId, this.createdAt, this.updatedAt});

  States.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["country_id"] is int) {
      countryId = json["country_id"];
    }
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["country_id"] = countryId;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}