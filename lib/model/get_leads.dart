
class GetLeads {
  String? message;
  bool? status;
  List<Leads>? leads;

  GetLeads({this.message, this.status, this.leads});

  GetLeads.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is bool) {
      status = json["status"];
    }
    if(json["leads"] is List) {
      leads = json["leads"] == null ? null : (json["leads"] as List).map((e) => Leads.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    if(leads != null) {
      _data["leads"] = leads?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Leads {
  int? id;
  String? name;
  String? mobileNo;
  String? description;
  String? country;
  String? zip;
  String? city;
  String? state;
  String? address;
  int? assigned;
  String? dateadded;
  int? status;
  int? source;
  String? lastcontact;
  String? dateassigned;
  int? addedfrom;
  String? email;
  String? dateConverted;
  int? lastLeadStatus;
  int? clientId;

  Leads({this.id, this.name, this.mobileNo, this.description, this.country, this.zip, this.city, this.state, this.address, this.assigned, this.dateadded, this.status, this.source, this.lastcontact, this.dateassigned, this.addedfrom, this.email, this.dateConverted, this.lastLeadStatus, this.clientId});

  Leads.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["mobile_no"] is String) {
      mobileNo = json["mobile_no"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["country"] is String) {
      country = json["country"];
    }
    if(json["zip"] is String) {
      zip = json["zip"];
    }
    if(json["city"] is String) {
      city = json["city"];
    }
    if(json["state"] is String) {
      state = json["state"];
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["assigned"] is int) {
      assigned = json["assigned"];
    }
    if(json["dateadded"] is String) {
      dateadded = json["dateadded"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["source"] is int) {
      source = json["source"];
    }
    if(json["lastcontact"] is String) {
      lastcontact = json["lastcontact"];
    }
    if(json["dateassigned"] is String) {
      dateassigned = json["dateassigned"];
    }
    if(json["addedfrom"] is int) {
      addedfrom = json["addedfrom"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["date_converted"] is String) {
      dateConverted = json["date_converted"];
    }
    if(json["last_lead_status"] is int) {
      lastLeadStatus = json["last_lead_status"];
    }
    if(json["client_id"] is int) {
      clientId = json["client_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["mobile_no"] = mobileNo;
    _data["description"] = description;
    _data["country"] = country;
    _data["zip"] = zip;
    _data["city"] = city;
    _data["state"] = state;
    _data["address"] = address;
    _data["assigned"] = assigned;
    _data["dateadded"] = dateadded;
    _data["status"] = status;
    _data["source"] = source;
    _data["lastcontact"] = lastcontact;
    _data["dateassigned"] = dateassigned;
    _data["addedfrom"] = addedfrom;
    _data["email"] = email;
    _data["date_converted"] = dateConverted;
    _data["last_lead_status"] = lastLeadStatus;
    _data["client_id"] = clientId;
    return _data;
  }
}