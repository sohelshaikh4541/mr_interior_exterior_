
class LeadSources {
  String? message;
  bool? status;
  List<Sources>? sources;

  LeadSources({this.message, this.status, this.sources});

  LeadSources.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["sources"] is List) {
      sources = json["sources"] == null ? null : (json["sources"] as List).map((e) => Sources.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(sources != null) {
      _data["sources"] = sources?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Sources {
  int? id;
  String? name;

  Sources({this.id, this.name});

  Sources.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}


class DropdownItem {
  final int id;
  final String name;

  DropdownItem({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }
}
