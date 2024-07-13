class GetProjectDropModel {
  String? message;
  bool? status;
  List<Data>? data;

  GetProjectDropModel({this.message, this.status, this.data});

  GetProjectDropModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? clientId;
  String? projectName;
  String? projectId;
  String? address;
  String? zip;
  String? city;
  String? state;
  String? date;
  int? packageId;
  String? price;
  int? createdBy;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? clientName;
  String? clientEmail;
  String? clientMobileNo;
  String? name;
  String? packageDescription;
  String? propertyType;

  Data(
      {this.id,
        this.clientId,
        this.projectName,
        this.projectId,
        this.address,
        this.zip,
        this.city,
        this.state,
        this.date,
        this.packageId,
        this.price,
        this.createdBy,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.clientName,
        this.clientEmail,
        this.clientMobileNo,
        this.name,
        this.packageDescription,
        this.propertyType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    projectName = json['project_name'];
    projectId = json['project_id'];
    address = json['address'];
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    date = json['date'];
    packageId = json['package_id'];
    price = json['price'];
    createdBy = json['created_by'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clientName = json['client_name'];
    clientEmail = json['client_email'];
    clientMobileNo = json['client_mobile_no'];
    name = json['name'];
    packageDescription = json['package_description'];
    propertyType = json['property_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['client_id'] = this.clientId;
    data['project_name'] = this.projectName;
    data['project_id'] = this.projectId;
    data['address'] = this.address;
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['state'] = this.state;
    data['date'] = this.date;
    data['package_id'] = this.packageId;
    data['price'] = this.price;
    data['created_by'] = this.createdBy;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['client_name'] = this.clientName;
    data['client_email'] = this.clientEmail;
    data['client_mobile_no'] = this.clientMobileNo;
    data['name'] = this.name;
    data['package_description'] = this.packageDescription;
    data['property_type'] = this.propertyType;
    return data;
  }
}
