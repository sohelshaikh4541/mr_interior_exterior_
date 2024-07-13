
class LeadStatus {
  String? message;
  bool? status;
  List<Statuses>? statuses;

  LeadStatus({this.message, this.status, this.statuses});

  LeadStatus.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["statuses"] is List) {
      statuses = json["statuses"] == null ? null : (json["statuses"] as List).map((e) => Statuses.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(statuses != null) {
      _data["statuses"] = statuses?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Statuses {
  int? id;
  String? status;

  Statuses({this.id, this.status});

  Statuses.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["status"] = status;
    return _data;
  }
}