class GetPaymentType {
  String? message;
  bool? status;
  List<Data>? data;

  GetPaymentType({this.message, this.status, this.data});

  GetPaymentType.fromJson(Map<String, dynamic> json) {
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
  String? paymentType;

  Data({this.id, this.paymentType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_type'] = this.paymentType;
    return data;
  }
}
